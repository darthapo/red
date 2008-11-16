# require File.dirname(__FILE__) + '/../spec_helper'
# require File.dirname(__FILE__) + '/fixtures/super'

describe "The super keyword" do |it| 
  it.calls " the method on the calling class" do
    Super::S1::A.new.foo([]).should_equal(["A#foo","A#bar"])
    Super::S1::A.new.bar([]).should_equal(["A#bar"])
    Super::S1::B.new.foo([]).should_equal(["B#foo","A#foo","B#bar","A#bar"])
    Super::S1::B.new.bar([]).should_equal(["B#bar","A#bar"])
  end
  
  it.can "searches the full inheritence chain" do
    Super::S2::B.new.foo([]).should_equal(["B#foo","A#baz"])
    Super::S2::B.new.baz([]).should_equal(["A#baz"])
    Super::S2::C.new.foo([]).should_equal(["B#foo","C#baz","A#baz"])
    Super::S2::C.new.baz([]).should_equal(["C#baz","A#baz"])
  end

  it.can "searches class methods" do
    Super::S3::A.new.foo([]).should_equal(["A#foo"])
    Super::S3::A.foo([]).should_equal(["A::foo"])
    Super::S3::A.bar([]).should_equal(["A::bar","A::foo"])
    Super::S3::B.new.foo([]).should_equal(["A#foo"])
    Super::S3::B.foo([]).should_equal(["B::foo","A::foo"])
    Super::S3::B.bar([]).should_equal(["B::bar","A::bar","B::foo","A::foo"])
  end

  it.calls " the method on the calling class including modules" do
    Super::MS1::A.new.foo([]).should_equal(["ModA#foo","ModA#bar"])
    Super::MS1::A.new.bar([]).should_equal(["ModA#bar"])
    Super::MS1::B.new.foo([]).should_equal(["B#foo","ModA#foo","ModB#bar","ModA#bar"])
    Super::MS1::B.new.bar([]).should_equal(["ModB#bar","ModA#bar"])
  end
  
  it.can "searches the full inheritence chain including modules" do
    Super::MS2::B.new.foo([]).should_equal(["ModB#foo","A#baz"])
    Super::MS2::B.new.baz([]).should_equal(["A#baz"])
    Super::MS2::C.new.baz([]).should_equal(["C#baz","A#baz"])
    Super::MS2::C.new.foo([]).should_equal(["ModB#foo","C#baz","A#baz"])
  end

  it.can "searches class methods including modules" do
    Super::MS3::A.new.foo([]).should_equal(["A#foo"])
    Super::MS3::A.foo([]).should_equal(["ModA#foo"])
    Super::MS3::A.bar([]).should_equal(["ModA#bar","ModA#foo"])
    Super::MS3::B.new.foo([]).should_equal(["A#foo"])
    Super::MS3::B.foo([]).should_equal(["B::foo","ModA#foo"])
    Super::MS3::B.bar([]).should_equal(["B::bar","ModA#bar","B::foo","ModA#foo"])
  end

  it.calls " the correct method when the method visibility is modified" do
    Super::MS4::A.new.example.should_equal(5)
  end
end
