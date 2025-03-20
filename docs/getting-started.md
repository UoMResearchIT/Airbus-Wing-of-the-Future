# From bootstrap to workflows! 
## Getting started with Galaxy

This guide will get you up and running with a self hosted Galaxy instance. The guide will cover the following steps:
- Prerequisites
- Starting Galaxy
- Accessing Galaxy
- Running tools
- Running workflows

### Prerequisites

To run Galaxy you will need to have Docker and Docker Compose installed on your machine. If you do not have these installed, you can find instructions on how to install them [here](https://docs.docker.com/get-docker/).

This guide assumes the use of a Linux environment. If you are using a different operating system, you may need to adjust the commands accordingly. WSL2 is a good option for running this stack on Windows machines.

### Starting Galaxy

To start Galaxy, you will need to clone this repository and navigate to the directory containing the `docker-compose.yml` file. You can do this by running the following commands:

```bash
git clone https://github.com/UoMResearchIT/Galaxy-Show-And-Tell.git
# git clone git@github.com:UoMResearchIT/Galaxy-Show-And-Tell.git (if using ssh)
cd Galaxy-Show-And-Tell
```

You must now configure the `.env` file to give some essential information to the Galaxy instance. You can do this by copying the `env.template` file to `.env` and editing the `.env` file:

> [!WARNING] 
> Please ensure there is a leading `.` before the `env` file. This is important for the `.env` file to be read by Docker Compose.

```bash
cp env.template .env
nano .env # or use your preferred text editor
```

There is one critically important variable in the `.env` file that must be set: `DOCKER_GID`.

This variable gives the Galaxy container access to the Docker socket on the host machine, allowing Galaxy to start other containers. To find the `DOCKER_GID`, you can run the following command:

```bash
getent group docker
```

The nummer in the output is the `DOCKER_GID`. You can now set this in the `.env` file.

Additionally, the `.env` file should contain the following information:
- `GALAXY_ADMIN_EMAIL`: The email address of the Galaxy administrator.
- `GALAXY_ADMIN_USER`: The username for the Galaxy administrator (must be lowercase).
- `GALAXY_ADMIN_PASS`: The password for the Galaxy administrator (can randomly generate this using a password manager).
- `GALAXY_API_KEY`: The API key for the Galaxy administrator (can randomly generate this using a password manager).

With the `.env` file configured, you can now start Galaxy by running the following command:

```bash
docker compose up -d
```

This starts Galaxy in the background. You can check the logs to see when Galaxy is ready by running:

```bash
docker compose logs -f
```

### Accessing Galaxy

Once Galaxy is ready, you can access it by navigating to `http://localhost:8080` in your web browser. You will be greeted by the Galaxy login page. You can log in using the credentials you set in the `.env` file to be logged in as the administrator.

### Running tools

You are now ready to get started with Galaxy! Let's run our first tool.

You can find tools in the left-hand panel of the Galaxy interface. Click on the `Tools` tab to see the available tools. You can search for tools using the search bar at the top of the panel.

Look for the section titled `Example tools`. Clicking this, you should find a handful of tools that are pre-installed in the Galaxy instance. You can run any of these tools by clicking on the tool name and following the instructions.

Let's try the `Word Count` tool first.

#### Running the Word Count tool

Click on the `Word Count` tool. You will be taken to a form where you an select options and give input to the tool.

Leave `Input Type` as `Text Input` and type an `Input String` of your choice in the field provided. Click `Run Tool` to run the tool.

> [!TIP]
> Can't think of an input string? Try `The quick brown fox jumps over the lazy dog`

The tool will run and you will be taken to the history panel where you can see the output of the tool. You can click on the output dataset to view the output.

#### Running other tools

You can run any of the example tools in the same way.

The `Letter Count` tool is a good next tool to try. This tool counts the number of each letter in the input. However, this tool *only* accepts a file as input. You can use the `Upload File` tool to upload a file to Galaxy, or the `Paste / Fetch Data` tool to create a file from text in Galaxy.

The `Histogram` tool is tailored to the output of the `Letter Count` tool. If you have run the `Letter Count` tool, you can use the output of that tool as input to the `Histogram` tool. This is essentially a very manual workflow! We will see how to make this more formal in the next section.

### Running workflows

Galaxy workflows are a way to chain tools together to create a more complex analysis. Workflows can be saved and shared, allowing you to reproduce analyses at a later date.

#### Example workflow

You can choose to run the example workflow first if you like. This workflow takes a text input, counts the number of each letter, and then creates a histogram of the letter counts.

The example workflow can be found at `Workflows` -> `Public Workflows` -> `Example tool workflow`. Click on the run icon to run the workflow or click `Import` to take your own copy of the workflow to edit.

#### Creating your own workflow

You can create your own workflow by clicking on the `Workflow` tab in the Galaxy interface, followed by the `Create` button. You can then drag tools from the left-hand panel into the workflow canvas and connect them together.

Start by creating an input (`Inputs` -> `Input dataset`), then drop the `Letter Count` tool onto the canvas. Connect the input to the `Letter Count` tool by dragging from the output of the input to the input of the `Letter Count` tool.

Next, drop the `Histogram` tool onto the canvas and connect the output of the `Letter Count` tool to the input of the `Histogram` tool.

You can now save the workflow and run it by clicking the `Run` button.

### Conclusion

You have now successfully started Galaxy, run some tools, and even created a workflow! 

This guide has only scratched the surface of what Galaxy can do, so feel free to explore the interface by yourself.

You can find guides on adding your own custom tools and public workflows elsewhere in this repository.


