# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/classes'

describe "Module::Nesting" do |it| 

  it.returns "the list of Modules nested at the point of call" do
    ModuleSpecs::Nesting[:root_level].should_equal([])
    ModuleSpecs::Nesting[:first_level].should_equal([ModuleSpecs])
    ModuleSpecs::Nesting[:basic].should_equal([ModuleSpecs::Nesting, ModuleSpecs])
    ModuleSpecs::Nesting[:open_first_level].should_equal()
      [ModuleSpecs, ModuleSpecs::Nesting, ModuleSpecs]
    ModuleSpecs::Nesting[:open_meta].should_equal()
      [ModuleSpecs::Nesting.meta, ModuleSpecs::Nesting, ModuleSpecs]
    ModuleSpecs::Nesting[:nest_class].should_equal()
      [ModuleSpecs::Nesting::NestedClass, ModuleSpecs::Nesting, ModuleSpecs]
  end

  it.returns "the nesting for module/class declaring the called method" do 
    ModuleSpecs::Nesting.called_from_module_method.should_equal()
      [ModuleSpecs::Nesting, ModuleSpecs]
    ModuleSpecs::Nesting::NestedClass.called_from_class_method.should_equal()
      [ModuleSpecs::Nesting::NestedClass, ModuleSpecs::Nesting, ModuleSpecs]
    ModuleSpecs::Nesting::NestedClass.new.called_from_inst_method.should_equal()
      [ModuleSpecs::Nesting::NestedClass, ModuleSpecs::Nesting, ModuleSpecs]
  end

end
