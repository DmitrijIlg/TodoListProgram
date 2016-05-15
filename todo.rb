module Menu
  def menu
    ' Welcome to the TodoList Program!
    This menu will help you use the Task List System
    1) Add
    2) Show
    3) Update
    4) Delete
    5) Write to a File
    6) Read from a File
    7) Toggle Status
    Q) Quit
    '
  end

  def show
    menu
  end

  def to_s
    description
  end

  def completed?
    status
  end

  def to_machine
    "#{represent_status} : #{description}"
  end
end

module Promptable
  def prompt (message = 'What would you like to do?', symbol = ':> ')
    print message
    print symbol
    gets.chomp
  end
end

class List
  attr_reader :all_tasks

  def initialize
    @all_tasks = []
  end

  def add (task)
    @all_tasks << task
  end

  def show
    #all_tasks.map.with_index {|l, i| "(#{i.next}): #{l}"}
    #all_tasks.length.time { |x|  all_tasks.map(&:to_machine)}
    i=0
    all_tasks.map do |element|
      i += 1
      "#{i}) " + element.to_machine
    end
    #all_tasks.each {|i,x| i + x}
  end

  def write_to_file (filename)
    machinified = @all_tasks.map(&:to_machine).join("\n")
    IO.write(filename, machinified)
  end

  def read_from_file (filename)
    IO.readlines(filename).each do |line|
      status, *description = line.split(':')
      status = status.include?('X')
      add(Task.new(description.join(':').strip, status))
    end
  end

  def delete (task_number)
        all_tasks.delete_at(task_number - 1)
  end

  def update (task_number, task)
    all_tasks[task_number - 1] = task
  end

  def toggle (task_number)
    puts "In List we change a task of
            #{all_tasks[task_number - 1].inspect}"
    all_tasks[task_number - 1].toggle_status
    puts "Now our task has this information
            #{all_tasks[task_number - 1].inspect}"
  end

end

class Task
  attr_reader :description
  attr_accessor :status

  def initialize (description, status = false)
    @description = description
    @status = status
  end

  private
  def represent_status
    "#{completed? ? '[X]' : '[ ]'}"
  end

  public
  def toggle_status
    @status = !completed?
  end
end

if __FILE__ == $PROGRAM_NAME
  include Menu
  include Promptable
  my_list = List.new
  puts 'Please choose from the following list'
  until ['q'].include?(user_input = prompt(show).downcase)
    case user_input
      when '1'
        my_list.add(Task.new(prompt('What is the task you would like to accomplish?')))
      when '2'
        puts my_list.show
      when '3'
        puts my_list.show
        my_list.update(prompt('Which task to update?').to_i,
        Task.new(prompt('Task Description?')))
      when '4'
        puts my_list.show
        my_list.delete(prompt('Which task to delete?').to_i)
      when '5'
        my_list.write_to_file(prompt('What is the filename to write to?'))
      when '6'
        begin
          my_list.read_from_file(prompt('What is the filename to read from?'))
        rescue Errno::ENOENT
          puts 'File name not found, please verify your file name and path.'
        end
      when '7'
        puts my_list.show
        my_list.toggle(prompt('Which would you like to toggle the
              status for?').to_i)
      else
        puts 'Sorry, I did not understand'
    end
    prompt('Press enter to continue', '')
  end
  puts 'Outro - Thanks for using the menu system!'
end
