---
title: Writing a guessing game in Crystal lang
# author: [Ilie Ploscaru]
date: 28 December 2018
subject: "Crystal Language"
# keywords: [Markdown, Example]
...

## Introduction  

I really wanted to write an introduction to crystal for some time now but didn't want to only write my take on the already well written [docs](https://crystal-lang.org/docs), so I thought I'd teach by example. (ie. being heavily inspired by [Rust docs](https://doc.rust-lang.org/book/second-edition/ch02-00-guessing-game-tutorial.html)

In this article I'll show you the basics of the [crystal](https://crystal-lang.org/) language by building a simple guessing game. It will introduce you to core concepts like variables, error handling, loops and more !

## Set up

For the instructions on installing crystal itself, just:  

_ go to the [official docs](https://crystal-lang.org/docs/installation/) and follow the instructions for your platform.

To set up a new project you'll have to `init`ialize it like so:

```bash
λ crystal init app guessing_game
λ cd guessing_game
```  

The first command, `crystal init`, takes `app` as the first argument which creates an application skeleton with the second argument, `guessing_game`, as the project name. 

## Processing a Guess

Our main file is in `src/guessing_game.cr`. Ignore `require` and `module` for now; better yet, delete everything in the file and start from zero.

The first part of the program will ask for user input, process that input, and check that the input is in the expected form.  

```ruby
# src/guessing_game.cr
puts "Guess a number!"
print "Please input your guess: "

guess = gets

puts "You guessed: #{guess}"
```  

`puts` prints the output to the screen with an '\n' (newline) afterwards. `print` is like `puts` minus the newline. `gets` waits for the user input which is then assigned to the variable `guess`.  

This line prints out the string we saved the user's input in. The syntax `#{}` is a placeholder that holds a value in place. You can print more than one value using `#{}`. Printing more than one value with `puts` would look like this:

```ruby
x = 5
y = 10

puts "x = #{x} and y = #{y}" # => "x = 5 and y = 10"
```

The `#` symbolizes the beginning of a comment. The comment will take up the rest of the line. As of yet there is no selective or multiline comment syntax in Crystal. The `# => ` syntax is officially used to describe the output of a line. 

_ (optional) You can read more about [variable assignment](https://crystal-lang.org/docs/syntax_and_semantics/assignment.html) or more about [strings](https://crystal-lang.org/docs/syntax_and_semantics/literals/string.html) on the official docs.

### Testing the first part

You can run the program so far like so:

```bash
λ crystal src/guessing_game.cr
Guess a number!
Please input your guess: 420
You guessed: 420
```  

At this point, the first part of the game is done: we’re getting input from the keyboard and then printing it.

## Generating a secret number  

Next, we need to generate a secret number that the user will try to guess. The secret number should be different every time so the game is fun to play more than once. Let's use a random number between 1 and 100 so the game isn't too difficult.

Generating a simple random number in Crystal is fairly easy with the help of the `rand` function. It takes an Int as the max range, so giving it 100 will generate numbers between 0 and 99. Wait what?

Yeah, apparently the `rand` function only generates numbers from 0 up until but not including the max value we give it. To get the range we want, we'll have to write `rand(100) + 1`, which will generate numbers between 1 and 100 - the range we're actually looking for!

Let's start using the built in `rand` function

```ruby
# src/guessing_game.cr
puts "Guess a number!"

secret_number = rand(100) + 1
puts "The secret number is: #{secret_number}"

print "Please input your guess: "
guess = gets

puts "You guessed: #{guess}"
```  

_ (optional) You can have a glance at the [Random](https://crystal-lang.org/api/master/Random.html) module on the [API docs](https://crystal-lang.org/api/master/)

It is always good to check the docs when you don't understand something, or when a StackOverflow answers get you only so far. At this point in time the documentation is extensive, but far from complete, and because the Crystal lang is written in itself, you can easily dive into the source code at any time to get a better understanding of the undelying concepts.  

The second line that we added to the code prints the secret number. This is useful while we’re developing the program to be able to test it, but we’ll delete it from the final version. It’s not much of a game if the program prints the answer as soon as it starts!  

Try running the program a few times:

```bash
λ cr src/guessing_game.cr
Guess a number!
The secret number is: 30
Please input your guess: 20
You guessed: 20

λ cr src/guessing_game.cr
Guess a number!
The secret number is: 96
Please input your guess: 92
You guessed: 92
```  

## Comparing guesses  

Now that we have user input and a random number, we can compare them:

```ruby
# src/guessing_game.cr
puts "Guess a number!"

secret_number = rand(100) + 1
puts "The secret number is: #{secret_number}"

print "Please input your guess: "
guess = gets

puts "You guessed: #{guess}"

if guess < secret_number
    puts "Too small!"
elsif guess > secret_number
    puts "Too big!"
else
    puts "You win!"
end
```  

Now, we could try using an `if, else` expression to compare our guesses.  

_ You can read more about [the `if` syntax on the docs.](https://crystal-lang.org/docs/syntax_and_semantics/if.html)

But, if we try to compile the program we get errors:

```bash
λ crystal src/guessing_game.cr
Error in src/guessing_game.cr:11: undefined method '<' for Nil (compile-time type is (String | Nil))

if guess < secret_number
            ^

Rerun with --error-trace to show a complete error trace.
```  

That might seem very alien at first, but the Crystal compiler is here to help us. Crystal is a statically typed, compiled language. When we run the program from the terminal, Crystal more or less just compiles the program without any optimization flags for a quick feedback loop while writing the program.  

### Union Types and Error Handling  

We don't say that guess should be a number, but the compiler infers the variable type from the `gets` function - because `gets` can be either a `String` when the user types in something or a `Nil` when he doesn't give any input, the Crystal compiler prepares itself for both outputs. `(String | Nil)` is called the [Union Type](https://crystal-lang.org/docs/syntax_and_semantics/union_types.html) of String and Nil.  

The compiler warns us that `guess` can be a `Nil` at compile time, which would break the whole program and doesn't allow us to go any further until we fix it.  

We just need to say that we want a valid input from the user, otherwise the whole code block should be ignored. We do that with something like:  

```ruby
# ...
print "Please input your guess: "
if guess = gets
    puts "You guessed: #{guess}"

    if guess < secret_number
    puts "Too small!"
    elsif guess > secret_number
    puts "Too big!"
    else
    puts "You win!"
    end
end
```  

### Type inference

By encapsulating `guess = gets` we ensure that when the `guess` is *not* `Nil`, the code block will run. If we tried to run the code, we'll run in another problem!

```bash
λ cr src/guessing_game.cr
Error in src/guessing_game.cr:10: no overload matches 'String#<' with type Int32
Overloads are:
- Comparable(T)#<(other : T)

    if guess < secret_number
```  

This just means that the compiler expected a number (ie. an `Int`), but got a `String` instead. What we now need to do is convert the string to an integer; and another problem could arise from that too, namely users who do not enter valid numbers !  

_ (optional) Have a look at Crystals [Type inference](https://crystal-lang.org/docs/syntax_and_semantics/type_inference.html) and [Exception Handling](https://crystal-lang.org/docs/syntax_and_semantics/exception_handling.html)  chapters.  

Converting an non-number string to an integer will raise an error. If you come from a C# or JavaScript background your first instinct, as was mine, was to use a `try..catch`. In crystal you do not merely 'catch' the error, you 'rescue' it with the `begin..rescue` syntax which is more or less identical to the `try..catch` one.  

The code will now look something like so:

```ruby
# ...
begin
    guessed_number = guess.to_i
rescue
    puts "#{guess} is not a number!"
    exit 1
end

puts "You guessed: #{guess}"

if guessed_number < secret_number
    puts "Too small!"
elsif guessed_number > secret_number
    # ...
```  

In the code block after `begin`, ie. in the one line, we expect an exception to be raised if the user doesn't enter a valid number. If the user happens to do so, the exception is catched and the program `rescue`d, ie. it will not just go down, crash and burn.  

It will instead run the code block after the `rescue` tag, where the behaviour of catching such an exception is defined. Take care of how you use the `begin..rescue` expression, because by supressing exceptions and not handling them properly you can introduce bugs into your code.  

![Image of stuff](/img/basics_vscode.png)

The code should now compile. Try it out ! If the user doesn't enter a valid number, you can now see the error message we implemented.  

## Looping  

The `loop` keyword gives us an infinite loop. Add that now to give users more chances at guessing the number:

```ruby
# src/guessing_game.cr
puts "Guess a number!"

secret_number = rand(100) + 1
puts "The secret number is: #{secret_number}"

loop do
    print "Please input your guess: "
    if guess = gets
    begin
        guessed_number = guess.to_i
    rescue
        puts "#{guess} is not a number!"
        exit 1
    end

    puts "You guessed: #{guess}"

    if guessed_number < secret_number
        puts "Too small!"
    elsif guessed_number > secret_number
        puts "Too big!"
    else
        puts "You win!"
    end
    end
end
```  

As you can see, we've moved everything into a loop from the guess input prompt onward. Be sure to indent those lines and run the program again. Notice that there is a new problem because the program is doing exactly what we told it to do: ask for another guess forever! It doesn't seem like the user can quit!  

The user could always halt the program by using the keyboard shortcut `Ctrl-C`. But there's another way to escape this insatiable monster: if the user enters a non-number answer, the program will crash. The user can take advantage of that in order to quit, as shown here:

```bash
λ crystal src/guessing_game.cr
Guess a number!
The secret number is: 19
Please input your guess: 42
You guessed: 42
Too big!
Please input your guess: 19
You guessed: 19
You win!
Please input your guess: quit
You guessed: quit
ERROR: this String cannot be converted to Int: quit
```  

Typing `quit` actually quits the game, but so will any other non-number input. However, this is suboptimal to say the least. We want the game to automatically stop when the correct number is guessed.

### Quitting After a Correct Guess

Let's program the game to quit when the user wins by adding a `break`:

```ruby
# src/guessing_game.cr
# ...
if guessed_number < secret_number
    puts "Too small!"
elsif guessed_number > secret_number
    puts "Too big!"
else
    puts "You win!"
    break
end
# ...
```  

By adding the `break` line after `You win!`, the program will exit the loop when the user guesses the secret number correctly. Exiting the loop also means exiting the program, because there are no more instructions to be run.  

Not quiting if the user enters a string would make the whole experience more enjoying. For that, we could replace the `exit 1` from the `begin..rescue` expression with a `next`.  

_ (optional) You can read more about the [Control expressions](https://crystal-lang.org/docs/syntax_and_semantics/control_expressions.html) from the docs.  

Now everything in the program should work as expected. Let's delete the `puts` that outputs the secret number, and try to actually `build` the program!

```bash
λ crystal build src/guessing_game.cr --release
```  

`build` compiles and packs your code into a runnable executable. The `--release` flag tells the compiler to apply optimizations which will make the program much faster, but the code will take longer to compile. You now have an executable `guessing_game` which you can run. Let's try running it:

```bash
λ ./guessing_game
Guess a number!
Please input your guess: 60
You guessed: 60
Too big!
Please input your guess: two
Please input your guess: three
Please input your guess: 44
You guessed: 44
Too big!
Please input your guess: 40
You guessed: 40
You win!
```  

This is the code so far:  

```ruby
# src/guessing_game.cr
puts "Guess a number!"

secret_number = rand(100) + 1
# puts "The secret number is: #{secret_number}"

loop do
    print "Please input your guess: "
    
    if guess = gets
    begin
        guessed_number = guess.to_i
    rescue
        puts "#{guess} is not a number!"
        next
    end

    puts "You guessed: #{guess}"

    if guessed_number < secret_number
        puts "Too small!"
    elsif guessed_number > secret_number
        puts "Too big!"
    else
        puts "You win!"
        break
    end
    end
end
```

### Refactoring

Even though everything works, the syntax looks a bit off and we could improve in some parts - eg. using `begin..rescue` is not the most optimal way to do it.

Until now `to_i` crashed upon failure, that's why we made good use of the `begin..rescue` statement. Thankfully there are other ways to do it. 

_ You can have a look at the [String](https://crystal-lang.org/api/master/String.html) section of the Crystal API where.

you can see the [`to_i?`](https://crystal-lang.org/api/master/String.html#to_i%3F%28base%3AInt%3D10%2Cwhitespace%3Dtrue%2Cunderscore%3Dfalse%2Cprefix%3Dfalse%2Cstrict%3Dtrue%29-instance-method) method. It acts exactly like we expect - execept it doesn't crash! It simply returns a `Nil` on failure.

That means that we could catch the error with a simple `if` statement. We could be even more fancy, and use the [`unless`](https://crystal-lang.org/docs/syntax_and_semantics/unless.html) statement, which is a negated if. Using it instead of `if ! ` makes the code easier to read. The refactored bit looks like this:

```ruby
# src/guessing_game.cr
# ...
    puts "You guessed: #{guess}"

    unless guess = guess.to_i?
    puts "#{guess} is not a number!"
    next
    end

    if guess < secret_number
# ...
```

Now, if the user enters something else rather than a number, the `to_i?` method will return a `Nil`, which will trigger the `unless` statement and skip to the `next` iteration in the loop.

As you can also see, after the refactor the extra variable `guessed_number` is made redundant. We can now just use `guess` instead in the whole program.

Another nifty thing we could do to get rid of the indendation after `if guess = gets` is to handle the negative case at the beginning of the loop. 

That's a good opportunity to show you a new syntax bit! Namely the use of the `if`, or `unless` statement as a suffix.

```ruby
# src/guessing_game.cr
# ...
print "Please input your guess: "

next unless guess = gets

# The above is the same as:
# unless guess = gets
#   next
# end

unless guess = guess.to_i?
#...
```

That way, the compiler will recognize that we handled the negative case first and that there are no runtime errors left to handle and let get rid of the extra indentation.

[RX14](https://github.com/rx14) pointed out another interesting nitpick. To [quote him](https://www.reddit.com/r/crystal_programming/comments/6qcxa3/writing_a_guessing_game_in_crystal_lang/dl91dfy/):
> `gets` will only return `nil` if the input IO was closed, which necessarily means that all future calls will return `nil` too. Using `next` instead of `break` in the `gets` guard statement will cause you  to enter an infinite loop if you use Ctrl-D (which closes the input file descriptor in the terminal).

By replacing the `next` before `gets` with a `break`, we will get the behaviour we expect when the user uses Ctrl-D.

This is the final version of the code:  

```ruby
# src/guessing_game.cr
puts "Guess a number!"
secret_number = rand(100) + 1
# puts "The secret number is: #{secret_number}" 2312312487189123456789123456789

loop do
    print "Please input your guess: "
    break unless guess = gets

    unless guess = guess.to_i?
    puts "#{guess} is not a number!"
    next
    end

    puts "You guessed: #{guess}"

    if guess < secret_number
    puts "Too small!"
    elsif guess > secret_number
    puts "Too big!"
    else
    puts "You win!"
    break
    end
end
```

## Summary

At this point you've successfully built the guessing game! Congratulations!

By doing that you've learned about the basics of variable assignment, control expressions, exception handling and the idiomatic way of doing things in Crystal.  

**From this point** I'd recommend you have a go at the [official Crystal Book](https://crystal-lang.org/docs/) if you haven't already, and [Crystal by Example](https://github.com/askn/crystal-by-example) is another resource that is always handy for a beginner. For a great introduction into Crystal app development try [Building a realtime Chat application with Crystal and Kemal](http://serdardogruyol.com/building-a-realtime-chat-app-with-crystal-and-kemal).

---

Many thanks to [RX14](https://github.com/rx14) for providing all the helpful feedback :) You can check his github to find loads of interesting projects, many of which written in Crystal!

Other great resources to learn: the [gitter](https://gitter.im/crystal-lang/crystal) channel is where a lot of nice and helpful people hang around - come by and say hi! If you have broader questions check out the [stack-overflow](https://stackoverflow.com/questions/tagged/crystal-lang) subsection for crystal-lang. There's also the [awesome-crystal](https://github.com/veelenga/awesome-crystal) list of projects where you can find most things crystal. And, of course, there's the [Crystal Weekly](http://www.crystalweekly.com/) which provides you with the latest news.
