Task Management Application Architecture & Design Decisions

Overview:
This application is a task management system built with Elixir and the Phoenix Framework. It is designed to allow multiple users to manage their tasks. Each task has a title, description, status, and due date. The application tracks task status changes and stores all data in an in-memory database using ETS (Erlang Term Storage).

Features:

    User Table- 
    Purpose:   Create User: Allows creating a new user with a username and password.
    Attributes:
            username (string)
            password (string)
            Password_hash (string)

    Task Table-
    Purpose: 
            Create Task: Allows the creation of a new task for a specific user.
            Retrieve Tasks: Retrieve all tasks for a specific user.
            Update Task: Updates the details of a specific task, including its status.
            Delete Task: Deletes a specific task.

    Attributes:
            title (string)
            description (string)
            status (string) - Possible values: ["TO DO", "IN PROGRESS", "DONE"]
            due_date (date)
            user_id (references User) - Each task belongs to a specific user

    Task Status Track Table- 
    Purpose: 
            Track Task Status Changes Records each change in the status of tasks to provide a history of status updates.
            List Task Status Changes: Lists all status changes for a specific task

    Attributes:

            task_id (references Task)
            changed_date (date)
            status_changed (string)


    In-Memory Database(ETS):

            The application utilizes ETS (Erlang Term Storage) as an in-memory database to store task records. Each task is stored as a tuple in the ETS table, allowing for efficient 
            retrieval, addition, update, and deletion operations.

    API Endpoints-
            User Endpoints:
                POST /users: Create a new user.

            Task Endpoints:

                POST /tasks : Create a new task for the specified user.
                GET /tasks_for_user/:user_id: Retrieve all tasks for the specified user.
                PUT /tasks/:id: Update a specific task for the specified user.
                DELETE /task/:id: Delete a specific task for the specified user.

            Task Status Track Endpoints:

                GET /tasks/:task_id/status_tracks: List all status changes for a specific task.


    Conclusion:- 

            This task management application leverages Elixir and Phoenix to provide a robust system for managing tasks across multiple users. With ETS as the underlying in-memory database, the application ensures high performance and efficient storage of task data. The inclusion of task status tracking enhances the functionality by providing a history of status changes for each task, allowing users to track the progress of their tasks effectively.






    To build and run the task management application

        Prerequisites:
            Ensure you have Elixir and Phoenix Framework installed on your system. You can follow the installation instructions from the following:
              * Official website: https://www.phoenixframework.org/
              * Guides: https://hexdocs.pm/phoenix/overview.html
              * Docs: https://hexdocs.pm/phoenix
              * Forum: https://elixirforum.com/c/phoenix-forum
              * Source: https://github.com/phoenixframework/phoenix

        Setup:
            Clone the repository containing the application source code:
            git clone https://github.com/EstharAlex/Task_management.git

        Navigate to the project directory:
            cd task_management

        Install dependencies:
            mix deps.get
            mix deps.compile

        Database Configuration:
            Install Postgres DB / Since we are using ETS as an in-memory database, no additional setup is required. ETS tables will be created automatically when the application starts.

        Running the Application
            Start the Phoenix server: mix phx.server

        This command will compile the project and start the server. By default, the server will be
        available at http://localhost:4000






