class TasksController < ApplicationController

  before_filter :login_required
    
  # GET /tasks
  # GET /tasks.xml
  def index
    filter_tasks(current_user.tasks)
    calculate_totals

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @incomplete_tasks }
    end
  end
  
  # GET /tasks/1
  # GET /tasks/1.xml
  def show
    @task = Task.find(params[:id])

    respond_to do |format|
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/new
  # GET /tasks/new.xml
  def new
    @task = Task.new(:user_id => current_user.id)

    respond_to do |format|
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/1/edit
  def edit
    @task = Task.find(params[:id])
    if @task.completed?
    	partial = 'completed'
    else
    	partial = 'edit'
    end
	logger.info "Completed? #{@task.completed?}"
    logger.info "Using partial: #{partial}"
    
    respond_to do |format|
    	format.html { render :partial => partial, :object => @task }
    end
  end

  # POST /tasks
  # POST /tasks.xml
  def create
    @task = Task.new(params[:task])
	@task.user_id = current_user.id
	
	logger.info "Completed: #{params[:task][:completed]}"
    @task.completed_at = Time.now if params[:task][:completed]
    logger.info "Completed At: #{@task.completed_at}"
    logger.info "Completed?: #{@task.completed?}"
    
    respond_to do |format|
      if @task.save
      	calculate_totals
        #flash[:notice] = 'Task was successfully created.'
        format.js # run the create.js.erb template
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
    
    logger.info "params[:task][:completed]: #{params[:task][:completed]}"
    @task.completed_at = Time.now if params[:task][:completed]
    logger.info "@task.completed?: #{@task.completed?}"

    respond_to do |format|
      if @task.save
      	calculate_totals
      	#flash[:notice] = 'Task was successfully updated.'
        format.js # run the update.js.rjs template
        format.xml  { head :ok }
      else
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
      format.js # run the destroy_completed.js.erb template
    end
  end
  
  def destroy_completed
  	filter_tasks(current_user.tasks)
  	logger.info "Destroying #{@completed_tasks.length} tasks."
  	for task in @completed_tasks
  		task.destroy
  	end
  	
  	respond_to do |format|
  		format.js # run the destroy_completed.js.erb template
  	end
  end
  
  protected #----------
  
  def filter_tasks(tasks)
  	@incomplete_tasks = []
    @completed_tasks = []
    
    for task in tasks
    	if task.completed?
    		@completed_tasks << task
		else
			# TODO - filter on date > 24 hours to populate the old tasks
			@incomplete_tasks << task
		end
    end
  end  
  
  def calculate_totals  	
  	@incomplete_total = 0
  	@completed_total = 0
  end
  
end
