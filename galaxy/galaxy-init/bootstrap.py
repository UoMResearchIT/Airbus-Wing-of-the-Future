import os
import json
import requests
from bioblend.galaxy import GalaxyInstance

tool_path = "/galaxy-workflows"


def get_api_key(gi):
    api_key = -1

    print("Checking for existing user")
    print(gi.users.get_users())
    for existing_user in gi.users.get_users():
        if (existing_user['email'] == "admin@hotmail.co.uk" or
            existing_user['username'] == "admin"):
            api_key = gi.users.get_or_create_user_apikey(existing_user['id'])

    # -----------------------------------------------------------------------------
    # If no existing user found, create user and get API key

    if api_key == -1:
        required_env_vars = ['GALAXY_ADMIN_USERNAME', 'GALAXY_ADMIN_EMAIL', 'GALAXY_ADMIN_PASSWORD']
        for var in required_env_vars:
            if var not in os.environ:
                raise Exception(f"{var} not set")

        user = gi.users.create_local_user(os.environ['GALAXY_ADMIN_USERNAME'],
                                          os.environ['GALAXY_ADMIN_EMAIL'],
                                          os.environ['GALAXY_ADMIN_PASSWORD'])
        api_key = gi.users.create_user_apikey(user['id'])

    return api_key

def get_workflow_name(workflow_file):
    with open(f"{tool_path}/{workflow_file}") as f:
        workflow = json.load(f)
        workflow_name = workflow['name']
    return workflow_name

def check_worfklow_imported(gi, workflow_name, workflows):
    if any(workflow_name in w['name'] for w in workflows):
        print(f"Workflow {workflow_name} already imported")
        return True
    return False

def add_workflows():

    # -----------------------------------------------------------------------------
    # Get galaxy instance

    gi = GalaxyInstance(url=os.environ['GALAXY_URL'],
                        key=os.environ['GALAXY_API_KEY'])
    print(f"Connected to Galaxy at {os.environ['GALAXY_URL']}")

    # --------------------------------------------------------------------------
    # Log in as admin user

    api_key = get_api_key(gi)
    gi = GalaxyInstance(url=os.environ['GALAXY_URL'], key=api_key)
    print(gi.users.get_current_user())
    user_id = gi.users.get_current_user()['id']

    # --------------------------------------------------------------------------
    # Import workflows if not already imported

    # Get current workflows
    workflows = gi.workflows.get_workflows()

    # Loop through workflow files
    for workflow_file in os.listdir(tool_path):
        workflow_name = get_workflow_name(workflow_file)

        # ----------------------------------------------------------------------
        # Import the workflow

        if check_worfklow_imported(gi, workflow_name, workflows) == False:
            workflow = gi.workflows.import_workflow_from_local_path(f"{tool_path}/{workflow_file}")
            print(f"Imported workflow {json.dumps(workflow)}")
        else:
            workflow = gi.workflows.get_workflows(name=workflow_name)[0]

        # ----------------------------------------------------------------------
        # Publish the workflow and add it to the menu

        workflow_id = workflow['id']
        result = gi.workflows.update_workflow(workflow_id,
                                              published=True,
                                              menu_entry=True)
        print(f"Published workflow with result {json.dumps(result)}")

        # ----------------------------------------------------------------------
        # Share with all users

        endpoint = f"{os.environ['GALAXY_URL']}/api/workflows/{workflow_id}/enable_link_access"
        params = {"key": api_key}
        response = requests.put(f"{endpoint}", params=params)
        print(json.dumps(response.json()))


if __name__ == "__main__":
    print("Bootstrapping Galaxy")

    add_workflows()
