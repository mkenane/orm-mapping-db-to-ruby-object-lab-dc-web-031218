class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student1 = self.new
    student1.id = row[0]
    student1.name = row[1]
    student1.grade = row[2]
    student1
  end

  def self.all
    sql = "SELECT * FROM students"
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    #  why can't I just itirate over the self.all array??? # self.all.map do |student_obj| # student_obj.find do |key, value|#   student_obj.name == name
      sql = "SELECT *
      FROM students
      WHERE name = (?)
      LIMIT 1"
   #why do we need map here? why can't we self.new_from_db(DB.execute(sql, name).first)
      DB[:conn].execute(sql, name).map do |row|
        self.new_from_db(row)
      end.first
    end

    def self.count_all_students_in_grade_9
      sql = "SELECT * FROM students WHERE grade = '9'"

      DB[:conn].execute(sql).map do |row|
        self.new_from_db(row)
      end
    end

    def self.students_below_12th_grade
      sql = "SELECT * FROM students WHERE NOT (grade = '12')"
      DB[:conn].execute(sql).map do |row|
        self.new_from_db(row)
      end
    end

def self.first_X_students_in_grade_10(x)
  sql = "SELECT * FROM students WHERE grade = '10' LIMIT (?)"
  DB[:conn].execute(sql, x).map do |row|
    self.new_from_db(row)
  end
end

def self.first_student_in_grade_10
  sql = "SELECT * FROM students WHERE grade = '10' LIMIT 1"
  DB[:conn].execute(sql).map do |row|
    self.new_from_db(row)
  end.first
end

def self.all_students_in_grade_X(x)
  sql = "SELECT * FROM students WHERE grade = (?)"
  DB[:conn].execute(sql, x).map do |row|
    self.new_from_db(row)
  end
end


  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end




end
