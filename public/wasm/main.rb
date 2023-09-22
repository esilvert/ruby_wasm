# frozen_string_literal: true

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
