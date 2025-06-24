<#import "template.ftl" as layout>
<@layout.emailLayout>
    <#assign subject>
        ${msg("passwordResetSubject")}
    </#assign>
    
    <#nested "subject">${subject}</#nested>
    
    <#nested "content">
        <h2>${msg("passwordResetGreeting", user.firstName!'')}</h2>
        
        <p>${msg("passwordResetBody1")}</p>
        
        <p>${msg("passwordResetBody2")}</p>
        
        <div class="button-container">
            <a href="${link}" class="email-button">${msg("passwordResetButton")}</a>
        </div>
        
        <p style="font-size: 14px; color: #64748b;">
            ${msg("passwordResetAlternative")}<br>
            <a href="${link}" style="color: #2563eb; word-break: break-all;">${link}</a>
        </p>
        
        <p style="font-size: 14px; color: #64748b;">
            ${msg("passwordResetExpiry", linkExpiration)}
        </p>
        
        <p style="font-size: 14px; color: #64748b;">
            ${msg("passwordResetIgnore")}
        </p>
    </#nested>
</@layout.emailLayout>