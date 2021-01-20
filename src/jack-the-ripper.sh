#!/usr/bin/env bash
#
# Determine if a DVD or BluRay has been inserted into the disc drive, and if it has rip the content into a location for
# further processing.

set -euo pipefail

LOG_FILE="/var/log/jack-the-ripper.log"
INGEST_DIRECTORY="/mnt/vault/Ingest"

# Logging utilities
function log::_timestamp() { date +'%Y-%m-%dT%H:%M:%S%z'; }
function log::info() { echo "$(log::_timestamp) [INFO] $*" >> "${LOG_FILE}"; }
function log::warn() { echo "$(log::_timestamp) [WARN] $*" >> "${LOG_FILE}"; }
function log::error() { echo "$(log::_timestamp) [ERROR] $*" >> "${LOG_FILE}"; }

# Rip the disc in order to archive the contents
function rip_disc() {
  local disc_name="${ID_FS_LABEL:-}"
  local working_dir="${INGEST_DIRECTORY}/${disc_name}"
  log::info "Detected name of the disc is ${disc_name} will save to ${working_dir}"

  # TODO: Actually do the ripping

  # TODO: Eject the disc
}

# Main entry point
function main() {
  log::info "Starting to process disc drive event"

  local dvd="${ID_CDROM_MEDIA_DVD:-}"
  local bluray="${ID_CDROM_MEDIA_BD:-}"

  if [[ "${bluray}" -eq "1" || "${dvd}" -eq "1" ]]; then
    log::info "It's a dvd or bluray, we should archive it"
    rip_disc
    log::info "Completed ripping the disc"
  else
    log::info "It's not a DVD or a BluRay, skipping processing"
    exit 0;
  fi
}
main "$@"
