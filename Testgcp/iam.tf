resource "google_service_account" "service_account" {
  account_id   = "perry15serviceaccount"
  display_name = "perry"
}
resource "google_service_account_iam_member" "admin-account-iam" {
  service_account_id = google_service_account.service_account.name
  role               = "roles/iam.serviceAccountUser"
  member             = "user:perrywak@yahoo.com"
}

