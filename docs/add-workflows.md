# Adding workflows to the instance

If you want to distribute your instance of Galaxy with workflows pre-installed, you can do so using this repository. The stages of workflow creation are as follows:
- Create the workflow using the Galaxy interface
- Export the workflow to a `.ga` file
- Add the workflow to the `galaxy/workflows` directory

> [!IMPORTANT] 
> This step is only necessary if you want to distribute your Galaxy instance with workflows pre-installed. If you hosting a Galaxy instance for others to use, you may simply create and share workflows using the Galaxy interface.

## Create the workflow using the Galaxy interface

You can create a workflow as outlined in the Tutorial or follow guides on the [Galaxy Training Network](https://training.galaxyproject.org/training-material/topics/introduction/).

Be sure to build in best practices such as using comments and annotations to make the workflow more understandable. It is advisable to set a license and a creator for the workflow.

## Export the workflow to a `.ga` file

Once you have created the workflow, you can save it to file. To do this, navigate to the `Workflows` tab in the Galaxy interface and find workflow you want to export. Click on the `Download workflow in .ga format` button to save the workflow to a `.ga` file.

## Add the workflow to the `galaxy/workflows` directory

For the workflow to be available in the Galaxy instance as a public workflow, you will need to add the `.ga` file to the `galaxy/workflows` directory. 

You will have to restart the Docker Compose for the workflow to be available.
