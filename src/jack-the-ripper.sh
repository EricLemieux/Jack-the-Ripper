#!/usr/bin/env bash
#
# Determine if a DVD or BluRay has been inserted into the disc drive, and if it has rip the content into a location for
# further processing.

set -euo pipefail

LOG_FILE="/var/log/jack-the-ripper.log"

# Logging utilities
function log::_timestamp() { date +'%Y-%m-%dT%H:%M:%S%z'; }
function log::info() { echo "$(log::_timestamp) [INFO] $*" >> "${LOG_FILE}"; }
function log::warn() { echo "$(log::_timestamp) [WARN] $*" >> "${LOG_FILE}"; }
function log::error() { echo "$(log::_timestamp) [ERROR] $*" >> "${LOG_FILE}"; }

# Main entry point
function main() {
  log::info "Some information"
  log::warn "Something bad happened"
  log::error "Uh oh, something broke"

  local dvd="${ID_CDROM_MEDIA_DVD:-}"
  local bluray="${ID_CDROM_MEDIA_BD:-}"
  local cd="${ID_CDROM_MEDIA_CD:-}"
  log::info "BluRay: ${bluray}"
  log::info "DVD: ${dvd}"
  log::info "CD: ${cd}"
}
main "$@"
