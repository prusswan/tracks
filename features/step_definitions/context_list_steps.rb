When /^I delete the context "([^\"]*)"$/ do |context_name|
  context = @current_user.contexts.find_by_name(context_name)
  context.should_not be_nil
  click_link "delete_context_#{context.id}"
  selenium.get_confirmation.should == "Are you sure that you want to delete the context '#{context_name}'? Be aware that this will also delete all (repeating) actions in this context!"
  wait_for do
    !selenium.is_element_present("delete_context_#{context.id}")
  end
end

When /^I edit the context to rename it to "([^\"]*)"$/ do |new_name|
  click_link "edit_context_#{@context.id}"

  wait_for do
    selenium.is_element_present("submit_context_#{@context.id}")
  end

  fill_in "context_name", :with => new_name

  selenium.click "submit_context_#{@context.id}",
    :wait_for => :text,
    :element => "flash",
    :text => "Context saved"

  wait_for do
    selenium.is_element_present("edit_context_#{@context.id}")
  end
end

When /^I add a new context "([^"]*)"$/ do |context_name|
  fill_in "context[name]", :with => context_name
  submit_new_context_form
end

When /^I add a new active context "([^"]*)"$/ do |context_name|
  When "I add a new context \"#{context_name}\""
end


When /^I add a new hidden context "([^"]*)"$/ do |context_name|
  fill_in "context[name]", :with => context_name
  check "context_hide"
  submit_new_context_form
end

Then /^I should see the context "([^"]*)" under "([^"]*)"$/ do |context_name, state|
  context = Context.find_by_name(context_name)
  response.should have_xpath("//div[@id='list-contexts-#{state}']//div[@id='context_#{context.id}']")
end