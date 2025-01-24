provider "aws" {
  profile = "developer-sandbox-administratoraccess"
}

variables {
  tags = {
    //Should be $pwd showing name of the testfile
    "Created_by": "automated Test autoscaling_apply",
    "Created_at": timestamp()
    // local exec - git config --get remote.origin.url
    "IaC_Module": "https://github.com/andsafe-AG/terraform-aws-dynamodb-table"
    // local exec - git branch
    "IaC_Branch": "main"
    // local exec - git log -1 --pretty=format:%h
    "IaC_Commit": "hash"
  }
}


run "basic_plan" {
  command = plan
  module {
    source = "./examples/basic"
  }
}

run "basic_apply" {
  command = apply

  module {
    source = "./examples/basic"
  }
  assert {
    condition     = module.dynamodb_table.dynamodb_table_id == format("my-table-%s", random_pet.this.id)
    error_message = "Name output produced unexpected result"
  }
  assert {
    condition     = can(regex("^arn:aws:dynamodb:[^:]+:[0-9]{12}:table/[a-zA-Z0-9-]+$", module.dynamodb_table.dynamodb_table_arn))
    error_message = format("ARN %s - output produced unexpected result", module.dynamodb_table.dynamodb_table_arn)
  }
}
