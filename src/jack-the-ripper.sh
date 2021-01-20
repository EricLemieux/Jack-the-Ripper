#!/usr/bin/env sh
#
# Determine if a DVD or BluRay has been inserted into the disc drive, and if it has rip the content into a location for
# further processing.

set -eu

LOG_FILE="/var/log/jack-the-ripper.log"
INGEST_DIRECTORY="/mnt/vault/Ingest"

# Logging utilities
log_timestamp() { date +'%Y-%m-%dT%H:%M:%S%z'; }
log_info() { echo "$(log_timestamp) [INFO] $*" >> "${LOG_FILE}"; }
log_warn() { echo "$(log_timestamp) [WARN] $*" >> "${LOG_FILE}"; }
log_error() { echo "$(log_timestamp) [ERROR] $*" >> "${LOG_FILE}"; }

# Rip the disc in order to archive the contents
rip_disc() {
  disc_name="${ID_FS_LABEL:-}"

  if [ -z "${disc_name}" ]; then
    log_error "Disc name was detected as empty, a human needs to investigate"
    exit 1
  fi

  working_dir="${INGEST_DIRECTORY}/${disc_name}"
  log_info "Detected name of the disc is ${disc_name} will save to ${working_dir}"

  mkdir -p "${working_dir}"
  makemkvcon --robot mkv disc:0 all "${working_dir}" >> "${LOG_FILE}" 2>&1

  # Sleep for a short period of time to hopefully ensure that MakeMKV is done processing
  sleep 10

  # Eject the disc to show the user that we are done
  eject /dev/sr0
}

# Main entry point
main() {
  log_info "Starting to process disc drive event"

  dvd="${ID_CDROM_MEDIA_DVD:-}"
  bluray="${ID_CDROM_MEDIA_BD:-}"

  if [ "${bluray}" -eq "1" ] || [ "${dvd}" -eq "1" ]; then
    log_info "It's a dvd or bluray, we should archive it"
    rip_disc
    log_info "Completed ripping the disc"
  else
    log_info "It's not a DVD or a BluRay, skipping processing"
    exit 0;
  fi
}
main "$@"
