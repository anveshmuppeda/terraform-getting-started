locals {
  eligibleToVote = var.age >= 18 ? "Eligible to Vote" : "Not Eligible to Vote"
}

resource "local_file" "vote_eligibility" {
  content  = local.eligibleToVote
  filename = "vote_eligibility.txt"
}