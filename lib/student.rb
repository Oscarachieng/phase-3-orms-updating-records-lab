require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  #initialize method
  attr_accessor :name, :grade, :id
  def initialize (name, grade, id = nil)
    @id = id
    @name = name
    @grade = grade
  end
#.create_table
def self.create_table 
  table_check_sql = "SELECT students FROM sqlite_master WHERE type='table' AND tbl_name='students';"
  if table_check_sql
     DB[:conn].execute("DROP TABLE IF EXISTS students;")
     DB[:conn].execute("CREATE TABLE IF NOT EXISTS students (id INTEGER PRIMARY KEY, name TEXT, grade TEXT;")
  else
     DB[:conn].execute("CREATE TABLE IF NOT EXISTS students (id INTEGER PRIMARY KEY, name TEXT, grade TEXT;")
  end

end
#.drop_table 
def self.drop_table
  table_check_sql = "SELECT students FROM sqlite_master WHERE type='table' AND tbl_name='students';"
  if table_check_sql
    DB[:conn].execute("DROP TABLE IF EXISTS students;")
  end
end

# object save method
def save 
  if self.id
    self.update
  else
    saved_student = DB[:conn].execute("INSERT INTO students (name,grade) VALUES (?,?);", self.name,self.grade)
    self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM students;")[0][0]
  end 
end
# .create method
def self.create (name:, grade:)
  student = Student.new(name: name, grade: grade)
  student.save
end

# .new_from_db
def self.new_from_db (data_from_db)
  self.new(id: data_from_db[0], name:data_from_db[1],grade:data_from_db[2])
end

# update method
def update 
  DB[:conn].execute("UPDATE students SET name = ?, grade = ? WHERE id = ?", self.name, self.grade,self.id)
end


end
