
=begin
满足的条件个数
4.	继承树中的类同时满足继承层次混乱的三个条件：
            1）树的最大深度超过4
            2）继承树中，所有类的最大子类数不超过2
            3）子类对父类的接口扩展率平均值小于1/4
5.	继承树中的类只满足继承层次混乱的任意两个条件
6.	继承树中的类只满足继承层次混乱的任意一个条件
7.	继承树中的类不满足继承层次混乱的任意条件

      类的位置：
      a. 所有类在同一文件中
      b. 所有类在同一文件夹中
      c. 所有类在不同文件夹中

      类的访问权限：
      public, private, protected

      类中扩展方法的属性：
      public, private, protected

      Note：子类继承父类的方法是否重写，未重写的也计入子类方法总数
      Note：第三方库中的类不计入继承层次

      语言： Java，CPP

      单继承， 多继承
=end

require 'tilt/erb'
require 'fileutils'
require 'faker'
require 'json'

require 'enumerator'

class JavaMethod
  attr_accessor :modifier, :name, :statement

  def initialize(modifier, name, statement)
    @modifier = modifier
    @name = name
    @statement = statement
  end
end

require 'erb'

class JavaClass
  include ERB::Util

  attr_accessor :package_name, :modifier, :class_name, :parent_class_name
  attr_accessor :methods

  def initialize(package_name="", modifier, class_name, parent_class_name, methods)
    @package_name = package_name
    @modifier = modifier
    @class_name = class_name
    @parent_class_name = parent_class_name || "Object"
    @methods= methods
  end

  def render()
    ERB.new(File.open('templates/class.erb', 'r').read).result(binding)
  end

  def save
    phy_path = "./#{@package_name.gsub(".", "/")}"
    FileUtils.mkdir_p(phy_path)
    File.open("#{phy_path}/#{class_name}.java", "w").write(self.render)
  end
end

def generate_class(java_class)
  template = Tilt::ERBTemplate.new('templates/class.erb')
  output = template.render(java_class)
  p output
  File.open("#{name}.java", "w").write(output)
end

def hier_generate(depth)
  names = (1..depth+1).map do ||
    Faker::Team.state.gsub(/\s*/, '')
  end

  names.unshift(nil)

  (0..depth).enum_for(:each_with_index).map do |current, index|
    {
      :class_name => names[index+1],
      :parent_class_name => names[index]
    }
  end

end

def case_generate(depth, sub_classes, extend_rate)
  puts hier_generate(depth).to_json

  methods = (0..3).enum_for(:each_with_index).map do |current, index|
    JavaMethod.new("public", "method#{index}", "System.out.println(\"method #{index} is invoked\")")
  end

  hier_generate(depth).each do |clazz|
    JavaClass.new("p1", "public", clazz[:class_name], clazz[:parent_class_name], methods).save
  end
  # 
  # java_class = JavaClass.new("p1", "public", "c1", nil, methods)
  # java_class.save
end

case_generate(4, 0, 0)
