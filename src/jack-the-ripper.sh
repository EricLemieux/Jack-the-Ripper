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

  if [[ -z "${disc_name}" ]]; then
    log::error "Disc name was detected as empty, a human needs to investigate"
    exit 1
  fi

  local working_dir="${INGEST_DIRECTORY}/${disc_name}"
  log::info "Detected name of the disc is ${disc_name} will save to ${working_dir}"

  mkdir -p "${working_dir}"
  makemkvcon --robot mkv disc:0 all "${working_dir}" >> "${LOG_FILE}" 2>&1

  # Sleep for a short period of time to hopefully ensure that MakeMKV is done processing
  sleep 10

  # Eject the disc to show the user that we are done
  eject /dev/sr0
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
