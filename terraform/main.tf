terraform {
	required_version = ">= 1.6.0"

	required_providers {
		azurerm = {
			source  = "hashicorp/azurerm"
			version = "~> 4.0"
		}
		random = {
			source  = "hashicorp/random"
			version = "~> 3.6"
		}
	}
}

provider "azurerm" {
	features {}
	subscription_id = var.subscription_id
}

locals {
	base_tags = {
		environment = "CP2"
		project     = var.project
		managed_by  = "terraform"
	}

	common_tags = merge(var.extra_tags, local.base_tags)
}
