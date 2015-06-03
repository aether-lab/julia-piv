module MyModule

export MyType, foo

type MyType
  x
end

bar(x) = 2x
foo(a::MyType) = bar(a.x) + 1

end



