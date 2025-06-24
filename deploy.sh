#!/bin/bash

# Sprantic Keycloak Theme Deployment Script
# This script helps deploy the Sprantic theme to a Keycloak installation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
KEYCLOAK_HOME="/opt/keycloak"
THEME_NAME="sprantic"
BACKUP_DIR="/tmp/keycloak-theme-backup-$(date +%Y%m%d-%H%M%S)"

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --help              Show this help message"
    echo "  -k, --keycloak-home     Keycloak installation directory (default: /opt/keycloak)"
    echo "  -n, --theme-name        Theme name (default: sprantic)"
    echo "  -b, --backup            Create backup before deployment"
    echo "  -r, --restart           Restart Keycloak after deployment"
    echo "  --docker                Deploy for Docker container"
    echo "  --dry-run               Show what would be done without making changes"
    echo ""
    echo "Examples:"
    echo "  $0                                    # Basic deployment"
    echo "  $0 -k /usr/local/keycloak -b -r      # Custom path with backup and restart"
    echo "  $0 --docker                          # Docker deployment"
    echo "  $0 --dry-run                         # Preview deployment"
}

# Parse command line arguments
BACKUP=false
RESTART=false
DOCKER=false
DRY_RUN=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_usage
            exit 0
            ;;
        -k|--keycloak-home)
            KEYCLOAK_HOME="$2"
            shift 2
            ;;
        -n|--theme-name)
            THEME_NAME="$2"
            shift 2
            ;;
        -b|--backup)
            BACKUP=true
            shift
            ;;
        -r|--restart)
            RESTART=true
            shift
            ;;
        --docker)
            DOCKER=true
            shift
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        *)
            print_error "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
done

# Set paths
THEMES_DIR="$KEYCLOAK_HOME/themes"
THEME_DIR="$THEMES_DIR/$THEME_NAME"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

print_status "Sprantic Keycloak Theme Deployment"
print_status "=================================="
print_status "Keycloak Home: $KEYCLOAK_HOME"
print_status "Theme Name: $THEME_NAME"
print_status "Theme Directory: $THEME_DIR"
print_status "Source Directory: $SCRIPT_DIR"

if [ "$DRY_RUN" = true ]; then
    print_warning "DRY RUN MODE - No changes will be made"
fi

# Check if running as root (needed for most installations)
if [ "$EUID" -ne 0 ] && [ "$DOCKER" = false ]; then
    print_warning "Not running as root. You may need sudo privileges."
fi

# Verify source files exist
if [ ! -f "$SCRIPT_DIR/theme.properties" ]; then
    print_error "Theme source files not found in $SCRIPT_DIR"
    print_error "Make sure you're running this script from the theme directory"
    exit 1
fi

# Check if Keycloak directory exists
if [ ! -d "$KEYCLOAK_HOME" ] && [ "$DOCKER" = false ]; then
    print_error "Keycloak directory not found: $KEYCLOAK_HOME"
    print_error "Use -k option to specify correct Keycloak installation path"
    exit 1
fi

# Create themes directory if it doesn't exist
if [ ! -d "$THEMES_DIR" ] && [ "$DOCKER" = false ]; then
    print_status "Creating themes directory: $THEMES_DIR"
    if [ "$DRY_RUN" = false ]; then
        mkdir -p "$THEMES_DIR"
    fi
fi

# Backup existing theme if requested
if [ "$BACKUP" = true ] && [ -d "$THEME_DIR" ]; then
    print_status "Creating backup of existing theme..."
    if [ "$DRY_RUN" = false ]; then
        mkdir -p "$BACKUP_DIR"
        cp -r "$THEME_DIR" "$BACKUP_DIR/"
        print_success "Backup created: $BACKUP_DIR/$THEME_NAME"
    else
        print_status "Would create backup: $BACKUP_DIR/$THEME_NAME"
    fi
fi

# Deploy theme files
print_status "Deploying Sprantic theme..."

if [ "$DOCKER" = true ]; then
    # Docker deployment
    print_status "Preparing Docker deployment..."
    if [ "$DRY_RUN" = false ]; then
        # Create a tar file for easy Docker copying
        tar -czf sprantic-theme.tar.gz \
            theme.properties \
            login/ \
            account/ \
            email/ \
            README.md \
            THEME-README.md
        print_success "Created sprantic-theme.tar.gz for Docker deployment"
        print_status "To deploy in Docker, use:"
        echo "  docker cp sprantic-theme.tar.gz container_name:/opt/keycloak/themes/"
        echo "  docker exec container_name tar -xzf /opt/keycloak/themes/sprantic-theme.tar.gz -C /opt/keycloak/themes/sprantic"
    else
        print_status "Would create sprantic-theme.tar.gz for Docker deployment"
    fi
else
    # Standard deployment
    if [ "$DRY_RUN" = false ]; then
        # Remove existing theme directory
        if [ -d "$THEME_DIR" ]; then
            rm -rf "$THEME_DIR"
        fi
        
        # Create theme directory
        mkdir -p "$THEME_DIR"
        
        # Copy theme files
        cp -r "$SCRIPT_DIR"/* "$THEME_DIR/"
        
        # Remove deployment script from theme directory
        rm -f "$THEME_DIR/deploy.sh"
        
        # Set proper permissions
        if command -v chown >/dev/null 2>&1; then
            if id "keycloak" >/dev/null 2>&1; then
                chown -R keycloak:keycloak "$THEME_DIR"
            fi
        fi
        chmod -R 755 "$THEME_DIR"
        
        print_success "Theme deployed successfully to $THEME_DIR"
    else
        print_status "Would deploy theme files to $THEME_DIR"
        print_status "Would set permissions: 755"
        if id "keycloak" >/dev/null 2>&1; then
            print_status "Would set owner: keycloak:keycloak"
        fi
    fi
fi

# Restart Keycloak if requested
if [ "$RESTART" = true ]; then
    print_status "Restarting Keycloak..."
    if [ "$DRY_RUN" = false ]; then
        if systemctl is-active --quiet keycloak; then
            systemctl restart keycloak
            print_success "Keycloak restarted successfully"
        elif command -v docker >/dev/null 2>&1; then
            # Try to restart Docker container
            CONTAINER_ID=$(docker ps --filter "ancestor=quay.io/keycloak/keycloak" --format "{{.ID}}" | head -n1)
            if [ -n "$CONTAINER_ID" ]; then
                docker restart "$CONTAINER_ID"
                print_success "Keycloak Docker container restarted"
            else
                print_warning "Could not find Keycloak service or container to restart"
            fi
        else
            print_warning "Could not restart Keycloak automatically"
            print_status "Please restart Keycloak manually"
        fi
    else
        print_status "Would restart Keycloak service"
    fi
fi

# Final instructions
print_success "Deployment completed!"
print_status ""
print_status "Next steps:"
print_status "1. Access Keycloak Admin Console"
print_status "2. Go to Realm Settings → Themes"
print_status "3. Set Login theme to: $THEME_NAME"
print_status "4. Set Account theme to: $THEME_NAME"
print_status "5. Set Email theme to: $THEME_NAME"
print_status "6. Click Save"
print_status ""
print_status "For detailed configuration, see THEME-README.md"

if [ "$BACKUP" = true ] && [ "$DRY_RUN" = false ]; then
    print_status ""
    print_status "Backup location: $BACKUP_DIR"
fi