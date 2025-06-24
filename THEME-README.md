# Sprantic Keycloak Theme

A modern, responsive, and accessible custom theme for Keycloak with a professional design and enhanced user experience.

## Features

- **Modern Design**: Clean, professional interface with gradient backgrounds and smooth animations
- **Responsive**: Fully responsive design that works on all devices
- **Accessible**: WCAG compliant with proper ARIA labels and keyboard navigation
- **Dark Mode Support**: Automatic dark mode detection and support
- **Multi-language**: Support for English, German, French, and Spanish
- **Custom Branding**: Sprantic branded with customizable colors and styling
- **Enhanced UX**: Loading states, smooth transitions, and interactive elements

## Theme Structure

```
keycloak-sprantic-theme/
├── theme.properties                 # Main theme configuration
├── login/                          # Login theme
│   ├── theme.properties            # Login theme configuration
│   ├── login.ftl                   # Main login template
│   ├── register.ftl                # Registration template
│   ├── login-reset-password.ftl    # Password reset template
│   ├── error.ftl                   # Error page template
│   ├── template.ftl                # Base template layout
│   ├── resources/css/
│   │   ├── login.css               # Main login styles
│   │   └── styles.css              # Additional utility styles
│   └── messages/
│       └── messages_en.properties  # English translations
├── account/                        # Account management theme
│   ├── theme.properties            # Account theme configuration
│   └── resources/css/
│       └── account.css             # Account management styles
└── email/                          # Email theme
    ├── theme.properties            # Email theme configuration
    └── html/
        ├── template.ftl            # Email template layout
        ├── password-reset.ftl      # Password reset email
        └── email-verification.ftl  # Email verification template
```

## Installation

### Method 1: Direct Deployment

1. **Copy theme to Keycloak**:
   ```bash
   # Copy the entire theme directory to Keycloak themes folder
   cp -r keycloak-sprantic-theme /opt/keycloak/themes/sprantic
   ```

2. **Set permissions**:
   ```bash
   chown -R keycloak:keycloak /opt/keycloak/themes/sprantic
   chmod -R 755 /opt/keycloak/themes/sprantic
   ```

3. **Restart Keycloak**:
   ```bash
   systemctl restart keycloak
   ```

### Method 2: Docker Deployment

1. **Using Docker volume**:
   ```bash
   docker run -d \
     --name keycloak \
     -p 8080:8080 \
     -v $(pwd)/keycloak-sprantic-theme:/opt/keycloak/themes/sprantic \
     -e KEYCLOAK_ADMIN=admin \
     -e KEYCLOAK_ADMIN_PASSWORD=admin \
     quay.io/keycloak/keycloak:latest start-dev
   ```

2. **Using Dockerfile**:
   ```dockerfile
   FROM quay.io/keycloak/keycloak:latest
   COPY keycloak-sprantic-theme /opt/keycloak/themes/sprantic
   ```

### Method 3: Kubernetes Deployment

1. **Create ConfigMap**:
   ```bash
   kubectl create configmap sprantic-theme --from-file=keycloak-sprantic-theme/
   ```

2. **Mount in Keycloak deployment**:
   ```yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: keycloak
   spec:
     template:
       spec:
         containers:
         - name: keycloak
           image: quay.io/keycloak/keycloak:latest
           volumeMounts:
           - name: sprantic-theme
             mountPath: /opt/keycloak/themes/sprantic
         volumes:
         - name: sprantic-theme
           configMap:
             name: sprantic-theme
   ```

## Configuration

### 1. Enable Theme in Keycloak Admin Console

1. Login to Keycloak Admin Console
2. Navigate to **Realm Settings** → **Themes**
3. Set the following themes:
   - **Login theme**: `sprantic`
   - **Account theme**: `sprantic`
   - **Email theme**: `sprantic`
4. Click **Save**

### 2. Realm-specific Configuration

For specific realms:
1. Navigate to your realm
2. Go to **Realm Settings** → **Themes**
3. Select `sprantic` for desired theme types
4. Click **Save**

## Customization

### Colors and Branding

Edit the CSS variables in [`login/resources/css/login.css`](login/resources/css/login.css):

```css
:root {
    --primary-color: #2563eb;        /* Main brand color */
    --primary-hover: #1d4ed8;        /* Hover state */
    --secondary-color: #64748b;      /* Secondary elements */
    --success-color: #10b981;        /* Success messages */
    --error-color: #ef4444;          /* Error messages */
    --warning-color: #f59e0b;        /* Warning messages */
    /* ... more variables */
}
```

### Logo and Branding

1. **Replace logo**: Add your logo to `login/resources/img/logo.png`
2. **Update brand name**: Edit the brand name in [`login/template.ftl`](login/template.ftl):
   ```html
   <span class="sprantic-brand">Your Brand</span>
   ```

### Custom Messages

Edit message files in [`login/messages/`](login/messages/) to customize text:

```properties
# login/messages/messages_en.properties
doLogIn=Sign In to Your Account
loginTitle=Welcome to {0}
# ... more messages
```

### Additional Languages

Create new message files for additional languages:
- `messages_de.properties` (German)
- `messages_fr.properties` (French)
- `messages_es.properties` (Spanish)

## Development

### Local Development Setup

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd keycloak-sprantic-theme
   ```

2. **Start Keycloak with theme**:
   ```bash
   docker run -d \
     --name keycloak-dev \
     -p 8080:8080 \
     -v $(pwd):/opt/keycloak/themes/sprantic \
     -e KEYCLOAK_ADMIN=admin \
     -e KEYCLOAK_ADMIN_PASSWORD=admin \
     quay.io/keycloak/keycloak:latest start-dev
   ```

3. **Enable theme caching disable** (for development):
   ```bash
   # Add to Keycloak startup
   --spi-theme-static-max-age=-1 --spi-theme-cache-themes=false --spi-theme-cache-templates=false
   ```

### File Watching

For automatic reloading during development:

```bash
# Watch for changes and restart Keycloak
fswatch -o . | xargs -n1 -I{} docker restart keycloak-dev
```

## Browser Support

- **Modern Browsers**: Chrome 90+, Firefox 88+, Safari 14+, Edge 90+
- **Mobile**: iOS Safari 14+, Chrome Mobile 90+
- **Accessibility**: WCAG 2.1 AA compliant

## Features in Detail

### Responsive Design
- Mobile-first approach
- Breakpoints at 480px, 768px, 1024px
- Touch-friendly interface elements

### Accessibility
- Proper ARIA labels and roles
- Keyboard navigation support
- High contrast mode support
- Screen reader compatibility

### Performance
- Optimized CSS with minimal dependencies
- Compressed assets
- Efficient animations using CSS transforms

### Security
- CSP-friendly (no inline styles in production)
- XSS protection through proper escaping
- Secure form handling

## Troubleshooting

### Theme Not Appearing

1. **Check file permissions**:
   ```bash
   ls -la /opt/keycloak/themes/sprantic
   ```

2. **Verify theme structure**:
   ```bash
   find /opt/keycloak/themes/sprantic -name "*.properties"
   ```

3. **Check Keycloak logs**:
   ```bash
   docker logs keycloak
   # or
   journalctl -u keycloak -f
   ```

### CSS Not Loading

1. **Clear browser cache**
2. **Check theme.properties** for correct CSS references
3. **Verify file paths** are correct

### Template Errors

1. **Check FreeMarker syntax** in `.ftl` files
2. **Verify variable names** match Keycloak context
3. **Check Keycloak version compatibility**

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with multiple Keycloak versions
5. Submit a pull request

## License

This theme is released under the MIT License. See LICENSE file for details.

## Support

For issues and questions:
- Create an issue in the repository
- Check existing documentation
- Review Keycloak theme development guide

## Changelog

### v1.0.0
- Initial release
- Login, account, and email themes
- Responsive design
- Multi-language support
- Accessibility features
- Dark mode support