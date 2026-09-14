use core_graphics::{
    display::CGDisplay,
    event::CGEvent,
    event_source::{CGEventSource, CGEventSourceStateID},
};
use serde::{Deserialize, Serialize};
use std::{fs, path::PathBuf};
use tauri::{AppHandle, LogicalPosition, LogicalSize, Manager, Position, WebviewWindow};

const PANEL_HEIGHT: f64 = 340.0;
const PANEL_WIDTH: f64 = 520.0;
const PANEL_GAP: f64 = 8.0;

#[derive(Deserialize)]
struct ItemQuery {
    bounding_rects: std::collections::BTreeMap<String, Rect>,
}

#[derive(Deserialize)]
struct Rect {
    origin: [f64; 2],
    size: [f64; 2],
}

#[derive(Deserialize, Serialize)]
#[serde(rename_all = "camelCase")]
struct City {
    country: String,
    iana_timezone: String,
    latitude: f64,
    locale: String,
    longitude: f64,
    name: String,
}

fn config_file(app: &AppHandle, name: &str) -> Result<PathBuf, String> {
    let directory = app
        .path()
        .app_config_dir()
        .map_err(|error| error.to_string())?;
    fs::create_dir_all(&directory).map_err(|error| error.to_string())?;
    Ok(directory.join(name))
}

fn cities_file(app: &AppHandle) -> Result<PathBuf, String> {
    config_file(app, "cities.json")
}

fn home_file(app: &AppHandle) -> Result<PathBuf, String> {
    config_file(app, "home-city.json")
}

#[tauri::command]
fn load_cities(app: AppHandle) -> Result<Option<Vec<City>>, String> {
    let file = cities_file(&app)?;
    if !file.exists() {
        return Ok(None);
    }

    let contents = fs::read_to_string(file).map_err(|error| error.to_string())?;
    serde_json::from_str(&contents)
        .map(Some)
        .map_err(|error| error.to_string())
}

#[tauri::command]
fn save_cities(app: AppHandle, cities: Vec<City>) -> Result<(), String> {
    let file = cities_file(&app)?;
    let temporary = file.with_extension("tmp");
    let contents = serde_json::to_vec_pretty(&cities).map_err(|error| error.to_string())?;
    fs::write(&temporary, contents).map_err(|error| error.to_string())?;
    fs::rename(temporary, file).map_err(|error| error.to_string())
}

#[tauri::command]
fn load_home_city(app: AppHandle) -> Result<Option<City>, String> {
    let file = home_file(&app)?;
    if !file.exists() {
        return Ok(None);
    }

    let contents = fs::read_to_string(file).map_err(|error| error.to_string())?;
    serde_json::from_str(&contents)
        .map(Some)
        .map_err(|error| error.to_string())
}

#[tauri::command]
fn save_home_city(app: AppHandle, city: City) -> Result<(), String> {
    let file = home_file(&app)?;
    let temporary = file.with_extension("tmp");
    let contents = serde_json::to_vec_pretty(&city).map_err(|error| error.to_string())?;
    fs::write(&temporary, contents).map_err(|error| error.to_string())?;
    fs::rename(temporary, file).map_err(|error| error.to_string())
}

#[tauri::command]
fn resize_panel(window: WebviewWindow, height: f64) -> Result<(), String> {
    window
        .set_size(LogicalSize::new(PANEL_WIDTH, height))
        .map_err(|error| error.to_string())
}

#[tauri::command]
fn hide_panel(window: WebviewWindow) -> Result<(), String> {
    window.hide().map_err(|error| error.to_string())
}

fn cursor_position() -> Option<(f64, f64)> {
    let source = CGEventSource::new(CGEventSourceStateID::HIDSystemState).ok()?;
    let event = CGEvent::new(source).ok()?;
    let point = event.location();
    Some((point.x, point.y))
}

fn contains(rect: &Rect, x: f64, y: f64) -> bool {
    x >= rect.origin[0]
        && x <= rect.origin[0] + rect.size[0]
        && y >= rect.origin[1]
        && y <= rect.origin[1] + rect.size[1]
}

fn position_for(query: &ItemQuery) -> Option<LogicalPosition<f64>> {
    let (cursor_x, cursor_y) = cursor_position()?;
    let item = query
        .bounding_rects
        .values()
        .find(|rect| contains(rect, cursor_x, cursor_y))
        .or_else(|| query.bounding_rects.values().next())?;
    let display_id = CGDisplay::displays_with_point(
        core_graphics::geometry::CGPoint::new(cursor_x, cursor_y),
        1,
    )
    .ok()?
    .0
    .into_iter()
    .next()?;
    let display = CGDisplay::new(display_id).bounds();
    let x = (item.origin[0] + item.size[0] / 2.0 - PANEL_WIDTH / 2.0).clamp(
        display.origin.x,
        display.origin.x + display.size.width - PANEL_WIDTH,
    );
    let y = (item.origin[1] + item.size[1] + PANEL_GAP).clamp(
        display.origin.y,
        display.origin.y + display.size.height - PANEL_HEIGHT,
    );

    Some(LogicalPosition::new(x, y))
}

fn toggle(app: &AppHandle, query: &str) {
    let Some(window) = app.get_webview_window("main") else {
        return;
    };

    if window.is_visible().unwrap_or(false) {
        let _ = window.hide();
        return;
    }

    let Ok(query) = serde_json::from_str::<ItemQuery>(query) else {
        return;
    };
    let Some(position) = position_for(&query) else {
        return;
    };

    let _ = window.set_position(Position::Logical(position));
    let _ = window.show();
    let _ = window.set_focus();
}

fn toggle_args(args: &[String]) -> Option<&str> {
    args.windows(2)
        .find(|pair| pair[0] == "--toggle")
        .map(|pair| pair[1].as_str())
}

fn main() {
    let args = std::env::args().collect::<Vec<_>>();
    tauri::Builder::default()
        .plugin(tauri_plugin_single_instance::init(|app, args, _| {
            if let Some(query) = toggle_args(&args) {
                toggle(app, query);
            }
        }))
        .setup(move |app| {
            app.set_activation_policy(tauri::ActivationPolicy::Accessory);
            app.set_dock_visibility(false);
            if let Some(query) = toggle_args(&args) {
                toggle(app.handle(), query);
            }
            Ok(())
        })
        .invoke_handler(tauri::generate_handler![
            hide_panel,
            load_cities,
            load_home_city,
            resize_panel,
            save_cities,
            save_home_city
        ])
        .run(tauri::generate_context!())
        .expect("error while running World Clock");
}
