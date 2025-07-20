# ###############################################################################
# # Dockerfile – Keycloak 26.2 with PostgreSQL build + SCIM plug-in (auto-fetch)
# ###############################################################################

# ######################## 0️⃣  Parameters you might tweak ######################
# # Pass SCIM_VERSION at build time if you want a different tag, e.g.
# #   docker build --build-arg SCIM_VERSION=2.2.2 -t my/keycloak:26.2-scim .
# ARG SCIM_VERSION=2.2.1
# # The download URL template (GitHub project: Captain-P-Goldfish/scim-for-keycloak)
# ARG SCIM_URL_TEMPLATE="https://github.com/Captain-P-Goldfish/scim-for-keycloak/releases/download/v${SCIM_VERSION}/scim-for-keycloak-kc-26-${SCIM_VERSION}-free.jar"

# ######################## 1️⃣  Fetch stage – download the JAR ##################
# FROM alpine:3.19 AS fetcher
# ARG SCIM_VERSION
# ARG SCIM_URL_TEMPLATE
# RUN apk add --no-cache curl ca-certificates && \
#     curl -L --fail -o /scim-plugin.jar "${SCIM_URL_TEMPLATE}"

# ######################## 2️⃣  Build/augmentation stage #######################
# FROM quay.io/keycloak/keycloak:26.2 AS builder

# # ---- Build-time config (becomes immutable under --optimized) ---------------
# ENV KC_DB=postgres \
#     KC_HEALTH_ENABLED=true \
#     KC_METRICS_ENABLED=true \
#     KC_FEATURES=token-exchange,admin-fine-grained-authz

# # Copy downloaded SCIM plug-in JAR into providers directory
# COPY --from=fetcher /scim-plugin.jar /opt/keycloak/providers/

# # Run Quarkus build once and strip temp files
# RUN /opt/keycloak/bin/kc.sh build --optimized && \
#     rm -rf /opt/keycloak/standalone/tmp/*

# ######################## 3️⃣  Runtime stage – slim, immutable ################
# FROM quay.io/keycloak/keycloak:26.2  AS runtime
# LABEL org.opencontainers.image.title="Keycloak 26 optimized w/ SCIM" \
#       org.opencontainers.image.description="Optimised Keycloak with SCIM-for-Keycloak plug-in auto-fetched at build time." \
#       maintainer="you@example.com"

# COPY --from=builder /opt/keycloak/ /opt/keycloak/
# USER 1000
# EXPOSE 8080 9000
# ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start", "--optimized"]
# ###############################################################################
