<#macro emailLayout>
<!DOCTYPE html>
<html lang="${locale}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title><#nested "subject"></title>
    <style>
        /* Reset styles */
        body, table, td, p, a, li, blockquote {
            -webkit-text-size-adjust: 100%;
            -ms-text-size-adjust: 100%;
        }
        
        table, td {
            mso-table-lspace: 0pt;
            mso-table-rspace: 0pt;
        }
        
        img {
            -ms-interpolation-mode: bicubic;
            border: 0;
            height: auto;
            line-height: 100%;
            outline: none;
            text-decoration: none;
        }
        
        /* Base styles */
        body {
            margin: 0 !important;
            padding: 0 !important;
            background-color: #f8fafc;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            font-size: 16px;
            line-height: 1.6;
            color: #1e293b;
        }
        
        .email-container {
            max-width: 600px;
            margin: 0 auto;
            background-color: #ffffff;
        }
        
        /* Header */
        .email-header {
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
            padding: 40px 30px;
            text-align: center;
        }
        
        .email-header h1 {
            margin: 0;
            color: #ffffff;
            font-size: 28px;
            font-weight: 700;
            text-decoration: none;
        }
        
        .sprantic-brand {
            color: #ffffff;
            font-weight: 700;
            font-size: 32px;
            margin: 0;
        }
        
        /* Content */
        .email-content {
            padding: 40px 30px;
        }
        
        .email-content h2 {
            color: #1e293b;
            font-size: 24px;
            font-weight: 600;
            margin: 0 0 20px 0;
        }
        
        .email-content p {
            color: #64748b;
            font-size: 16px;
            line-height: 1.6;
            margin: 0 0 20px 0;
        }
        
        /* Button */
        .email-button {
            display: inline-block;
            padding: 16px 32px;
            background-color: #2563eb;
            color: #ffffff !important;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 16px;
            margin: 20px 0;
            transition: background-color 0.15s ease;
        }
        
        .email-button:hover {
            background-color: #1d4ed8;
        }
        
        .button-container {
            text-align: center;
            margin: 30px 0;
        }
        
        /* Footer */
        .email-footer {
            background-color: #f8fafc;
            padding: 30px;
            text-align: center;
            border-top: 1px solid #e2e8f0;
        }
        
        .email-footer p {
            color: #64748b;
            font-size: 14px;
            margin: 0 0 10px 0;
        }
        
        .email-footer a {
            color: #2563eb;
            text-decoration: none;
        }
        
        /* Responsive */
        @media only screen and (max-width: 600px) {
            .email-container {
                width: 100% !important;
            }
            
            .email-header,
            .email-content,
            .email-footer {
                padding: 20px !important;
            }
            
            .email-header h1 {
                font-size: 24px !important;
            }
            
            .sprantic-brand {
                font-size: 28px !important;
            }
            
            .email-content h2 {
                font-size: 20px !important;
            }
        }
        
        /* Dark mode support */
        @media (prefers-color-scheme: dark) {
            .email-container {
                background-color: #1e293b !important;
            }
            
            .email-content {
                background-color: #1e293b !important;
            }
            
            .email-content h2 {
                color: #f1f5f9 !important;
            }
            
            .email-content p {
                color: #94a3b8 !important;
            }
            
            .email-footer {
                background-color: #0f172a !important;
            }
        }
    </style>
</head>
<body>
    <div class="email-container">
        <!-- Header -->
        <div class="email-header">
            <h1 class="sprantic-brand">Sprantic</h1>
        </div>
        
        <!-- Content -->
        <div class="email-content">
            <#nested "content">
        </div>
        
        <!-- Footer -->
        <div class="email-footer">
            <p>${msg("emailFooter")}</p>
            <p>
                <a href="${properties.adminUrl!}">${msg("emailFooterAdmin")}</a> |
                <a href="${properties.supportUrl!}">${msg("emailFooterSupport")}</a>
            </p>
            <p style="font-size: 12px; color: #94a3b8;">
                ${msg("emailFooterCopyright", .now?string("yyyy"))}
            </p>
        </div>
    </div>
</body>
</html>
</#macro>