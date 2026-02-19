# Use Keycloak Container
FROM quay.io/keycloak/keycloak:26.5.3 as builder

# Install custom Keycloak theme
ADD --chown=keycloak:keycloak https://github.com/ALMiG-Kompressoren-GmbH/tailcloakify/releases/download/v1.2.2/keycloak-theme-for-kc-22-to-25.jar /opt/keycloak/providers/tailcloakify-theme.jar
FROM quay.io/keycloak/keycloak:26.5.3

COPY --from=builder /opt/keycloak /opt/keycloak
WORKDIR /opt/keycloak

# Keycloak environment variables
ENV KC_HOSTNAME_STRICT=false
ENV KC_HTTPS_PORT=8443
ENV KC_HTTPS_PROTOCOLS=TLSv1.3,TLSv1.2
ENV KC_HTTP_ENABLED=true
ENV KC_HTTP_PORT=8080
ENV KC_BOOTSTRAP_ADMIN_USERNAME=admin
ENV KC_BOOTSTRAP_ADMIN_PASSWORD=admin
ENV KC_LOG_CONSOLE_FORMAT=json
ENV KC_TRACING_ENABLED=true
ENV KC_TRACING_ENDPOINT=http://alloy:4317/v1/traces
ENV KC_TRACING_SAMPLER_TYPE=parentbased_traceidratio
ENV KC_TRACING_SAMPLER_PARAM=1
ENV KC_METRICS_ENABLED=true
ENV KC_METRICS_EXPORTER_PROMETHEUS_ENABLED=true
ENV KC_METRICS_EXPORTER_PROMETHEUS_PORT=9100
ENV KC_HTTP_MANAGEMENT_PORT=9000  

# Custom Keycloak theme environment variables
ENV TAILCLOAKIFY_ADDITIONAL_SCRIPTS="Cookie Script Here"
ENV TAILCLOAKIFY_BACKGROUND_LOGO_URL=""
ENV TAILCLOAKIFY_BACKGROUND_IMAGE_URL=""
ENV TAILCLOAKIFY_BACKGROUND_VIDEO_URL=""
ENV TAILCLOAKIFY_FOOTER_IMPRINT_URL="Impressum URL Here"
ENV TAILCLOAKIFY_FOOTER_DATAPROTECTION_URL="Data Protection URL Here"
ENV TAILCLOAKIFY_FOOTER_ORESTBIDACOOKIECONSENT="true"
ENV TAILCLOAKIFY_EMAIL_BACKGROUND_IMAGE_URL: "https://mailwind.blob.core.windows.net/website/blurred-background-transparency.jpg"
ENV TAILCLOAKIFY_EMAIL_LOGO: ""
ENV TAILCLOAKIFY_EMAIL_FONT_FAMILY: ""
ENV TAILCLOAKIFY_EMAIL_CONTACT: ""

ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start"]
