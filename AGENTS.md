# Trip Routing System - Agent Context

## Project Overview

The Trip Routing System is a Ruby on Rails web application designed for creating and managing travel plans. It provides features for creating trip schedules, automatically optimizing visit order, and exporting to iCalendar format for import into calendar applications like Google Calendar. The system can operate offline after installation.

### Key Features
- Travel itinerary creation and management
- Automatic optimization of visit order using routing algorithms
- Export to iCalendar format for calendar integration
- Offline operation capability
- Integration with OpenStreetMap for maps, routing, and geocoding

### Architecture
The system consists of multiple interconnected services:
- **Main Rails Application**: Handles trip management, UI, and business logic
- **OpenStreetMap Tile Server**: Provides map tiles for visualization
- **Valhalla**: Routing engine for calculating optimal routes
- **Nominatim**: Geocoding service for converting addresses to coordinates
- **SQLite Database**: Stores trip data locally

### Core Models
- **Trip**: Main entity representing a travel plan
- **Day**: Represents a day within a trip, contains waypoints
- **Waypoint**: Specific location within a day, with coordinates and name

## Building and Running

### Prerequisites
- Docker and Docker Compose
- OSM map data file (e.g., japan-latest.osm.pbf)

### Setup Process
1. Download map data from Geofabrik: `wget https://download.geofabrik.de/asia/japan-latest.osm.pbf`
2. Build the application: `docker compose build`
3. Start services: `docker compose up`
4. Access the application at: http://localhost:3009

### Development Commands
```bash
# Install dependencies
bundle install

# Run tests
bundle exec rspec

# Run the application locally
rails server

# Start development server and related services
./bin/dev

# Precompile assets
rails assets:precompile

# Run database migrations
rails db:migrate
```

### Development Server
The application provides a development server script `./bin/dev` that starts all necessary development services using the `Procfile.dev` configuration. This includes:
- Rails web server on port 3000
- JavaScript watcher for asset compilation
- Guard for automated testing/style checking
- Docker Compose services for external dependencies
- OAuth2 proxy (if configured)

### Production Deployment
The application is designed to run in Docker containers with the following services:
- Rails application server
- Nginx proxy
- PostgreSQL for tile server
- Valhalla routing engine
- Nominatim geocoder

## Development Conventions

### Code Style
- Ruby code follows standard Ruby/Rails conventions
- RuboCop is used for code style enforcement (configured in `.rubocop.yml`)
- JavaScript code follows modern ES6+ standards

### Testing
- RSpec is used for testing (configuration in `.rspec`)
- Factory Bot is available for test data generation
- Capybara and Cuprite for system testing

### Internationalization
- The application supports Japanese as the default locale
- Translation files are located in `config/locales`

### Frontend Assets
- JavaScript bundling handled by jsbundling-rails using esbuild
- CSS preprocessing with SassC
- Leaflet for map visualization
- Stimulus for lightweight JavaScript interactions

## Key Dependencies

### Backend
- Ruby 3.2.7
- Rails 7.2.0+

- SQLite3 database
- Faraday for HTTP requests
- Open Location Code gem for Plus Codes
- iCalendar gem for calendar exports

### Frontend
- Leaflet for interactive maps
- SortableJS for drag-and-drop functionality
- Spectre.css for UI styling
- Material Icons for iconography
- Turbo and Stimulus from Hotwire framework

### External Services
- OpenStreetMap tile server
- Valhalla routing engine
- Nominatim geocoding service

## File Structure
```
app/                    # Rails application code
├── controllers/        # MVC controllers
├── models/            # ActiveRecord models
├── views/             # View templates
├── javascript/        # JavaScript code
└── assets/            # Static assets
config/                 # Configuration files
├── routes.rb          # Application routes
├── application.rb     # Main application configuration
└── settings.yml       # Service endpoint settings
db/                     # Database schema and migrations
spec/                   # Test files
vendor/                 # Third-party Docker configurations
```

## Environment Configuration
- Settings for external service endpoints are configured in `config/settings.yml`
- The application expects services to be available at specific endpoints:
  - Tiles: `http://localhost:3001/tiles/`
  - Routing: `http://localhost:3001/routing`
  - Search: `http://localhost:3001/search`

## Special Considerations
- Initial startup requires importing map data which can take several hours
- High memory consumption during map data import (recommend adding swap space)
- The system is designed primarily for Japan region (based on documentation)
- Plus Codes are supported for location identification