# Simple GKE Terraform

Manages a Google Kubernetes Engine (GKE) cluster. For more information see [the official documentation](https://cloud.google.com/container-engine/docs/clusters) and [the API reference](https://cloud.google.com/kubernetes-engine/docs/reference/rest/v1beta1/projects.locations.clusters).

## Prerequisites

Make sure you have installed and configured all of the following prerequisites on your development machine and GCP:

- Terraform - [Download & Install Terraform](https://www.terraform.io/downloads.html). The current latest version of Terraform is 0.13.5.
- Gcloud - [Install Google Cloud SDK](https://cloud.google.com/sdk/docs/install). A set of tools that you can use to manage resources and applications hosted on Google Cloud.
- A Google Cloud Platform account. You can [get $300 to try Google Cloud](https://cloud.google.com/gcp/).
- A [Google Cloud Storage](https://cloud.google.com/storage/docs/creating-buckets) bucket for Terraform backend.

## Usage

Clone this repository to your development machine and make sure that you have done all of prerequisites above.

First, you have to open file [terraform.tfvars](terraform.tfvars) then edit some variables match to your GCP project and GKE cluster which you want to create.

Then run the following commands. You've been warned that this action may cost your money if your GCP account is not in the Free trial period.

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

If you don't want to type the confirmation YES for `terraform apply`, please add option --auto-approve: `terraform apply --auto-approve`

Destroy the resources that are created by Terraform after `terraform apply` finishes successfully:

```bash
$ terraform destroy
# or terraform destroy --auto-approve if you don't want to confirm the prompt.
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)