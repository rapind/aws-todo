class TasksController < ApplicationController

  before_filter :login_required
  
  # GET /tasks
  # GET /tasks.xml
  def index  	
    @incomplete_tasks = current_user.incomplete_tasks
    @complete_tasks = current_user.complete_tasks
    
    calculate_totals

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tasks }
    end
  end
  
  # GET /tasks/1
  # GET /tasks/1.xml
  def show
    @task = Task.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/new
  # GET /tasks/new.xml
  def new
    @task = Task.new(:user_id => current_user.id)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/1/edit
  def edit
    @task = Task.find(params[:id])
  end

  # POST /tasks
  # POST /tasks.xml
  def create
    @task = Task.new(params[:task])
	@task.user_id = current_user.id

    respond_to do |format|
      if @task.save
      	calculate_totals
        #flash[:notice] = 'Task was successfully created.'
        format.html { redirect_to(tasks_path) }
        format.js # run the create.js.rjs template
        format.xml  { render :xml => @task, :status => :created, :location => @task }
      else
        format.html { render :action => "index" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /tasks/1
  # PUT /tasks/1.xml
  def update
    @task = Task.find(params[:id])
    # We need to use load then save instead of update_attributes with active resource models
    @task.load(params[:task])
    
    if @task.complete and @task.completed_at.nil?
    	@task.complete = 1
    	@task.completed_at = Time.now
    else
    	@task.complete = 0
    	@task.completed_at = nil
    end

    respond_to do |format|
      if @task.save
      	calculate_totals
        #flash[:notice] = 'Task was successfully updated.'
        format.html { redirect_to(tasks_path) }
        format.js # run the update.js.rjs template
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.xml
  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    #calculate_totals

    respond_to do |format|
      format.html { redirect_to(tasks_path) }
      format.js # run the destroy.js.rjs template
      format.xml  { head :ok }
    end
  end
  
  protected #----------
  
  def calculate_totals
  	@task_totals = 0 #Task.sum :value
  end
  
end