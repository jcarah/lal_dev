import looker_sdk
from looker_sdk import models31 as models
import sys
import prettyprinter
prettyprinter.install_extras(include=['attrs'])

sdk = looker_sdk.init31()
project = 'jesse_the_look'

def main():
    checkout_dev_branch(sys.argv[1], project)
    lookml_errors = sdk.validate_project(project_id=project).errors
    prettyprinter.pprint((lookml_errors))
    # Assert no new errors introduced in dev branch
    for error in lookml_errors:
        assert error.kind != 'error', """
            Uh oh, there are LookML Validation errors in your branch :-(
            Please go and fix that before merging your commit
            """

def checkout_dev_branch(branch_name, project_name):
    """Enter dev workspace"""
    sdk.update_session(models.WriteApiSession(workspace_id='dev'))
    branch = models.WriteGitBranch(name=branch_name)
    sdk.update_git_branch(project_id=project_name, body=branch)

main()

