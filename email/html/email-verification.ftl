<#import "template.ftl" as layout>
<@layout.emailLayout>
    <#assign subject>
        ${msg("emailVerificationSubject")}
    </#assign>
    
    <#nested "subject">${subject}</#nested>
    
    <#nested "content">
        <h2>${msg("emailVerificationGreeting", user.firstName!'')}</h2>
        
        <p>${msg("emailVerificationBody1")}</p>
        
        <p>${msg("emailVerificationBody2")}</p>
        
        <div class="button-container">
            <a href="${link}" class="email-button">${msg("emailVerificationButton")}</a>
        </div>
        
        <p style="font-size: 14px; color: #64748b;">
            ${msg("emailVerificationAlternative")}<br>
            <a href="${link}" style="color: #2563eb; word-break: break-all;">${link}</a>
        </p>
        
        <p style="font-size: 14px; color: #64748b;">
            ${msg("emailVerificationExpiry", linkExpiration)}
        </p>
        
        <p style="font-size: 14px; color: #64748b;">
            ${msg("emailVerificationIgnore")}
        </p>
    </#nested>
</@layout.emailLayout>