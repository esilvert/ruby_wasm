# Ruby WASM

## Why this project ? 
I was reading Ruby Weekly from 21-09-2023 and there was an article about "An introduction to Ruby in the browser". 

This article linked to [this video](https://www.youtube.com/watch?v=4AdcfbI6A4c&ab_channel=montreal-rb) that happened to best very interesting and motivated me to test on my own. 

## What is this project ? 
Simply talking, it's a rails app (generated with `--minimalist` tag) that serves Bootstrap, ruby WASM and then my own ruby file to be executed in the browser. 

So the single file interesting is the `public/wasm/main.rb` that is what we can see below. 

## How does it work ? 

The WebAssembly ? Well I can't relly explain that easily, but this project is a single `main.rb` that generates a form; wait for you to submit a question and then answers it with a 99% success rate (tested locally, other tests may have different results).

## Demo


https://github.com/esilvert/ruby_wasm/assets/94843168/3b45337a-df60-4e86-8fa7-d187c175ef5c

## Diving in 
### The initialization 

```rb

puts 'Starting App'

require 'js'

$document = JS.global[:document]
$window = JS.global[:window]
$body = $document.getElementsByTagName('body')[0]

# ==================================================

def create_node(type, parent = nil, **props)
  node = $document.createElement(type)

  props.each do |prop_name, prop_value|
    node[prop_name] = prop_value
  end

  yield node if block_given?

  if parent.nil?
    $body.appendChild(node)
  else
    parent.appendChild(node)
  end
end

```
It maps the global variable of javascript (such as `document` and `window`) into global variable in ruby. 

Then it defined a `create_node` method that allowed me to easily add a node to the document with given attributes.

## Form Logic

```rb

create_node('form', nil, classList: "container d-flex flex-column p-5") do |form|
  create_node('label', form, for: 'question' ) do |label|
    label[:innerText] = "Ask a question that answers by Yes or No, and I'll tell you the future."
  end

  question = create_node('input', form, type: 'text', classList: 'my-1')

  button = create_node('button', form, type: 'submit', innerText: 'Ask')

  answer = create_node('p', form)

  button.addEventListener('click') do |event|
    event.preventDefault

    answer[:innerText] = if question[:value] == JS.try_convert('')
                           "You didn't ask for anything, Darling."
                         else
                           ['Yes', 'No', "I don't really know, ask me again ?"].sample
                         end
  end

end
```

Here is what happend quickly: 
- It creates a node that 
  1. Creates a `label`
  2. Creates an `input` that will contain the user's question
  3. Creates a `button` (the submit button)
  4. Create a `p` that will contain the answer
 
While creating the submit button, we recorded a callback on the click that updates the `innerText` of the `p`.

That's it, thanks !
