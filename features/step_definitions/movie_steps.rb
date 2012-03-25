# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
  end
  assert movies_table.hashes.size == Movie.all.count
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  titles = page.all("table#movies tbody tr td[1]").map {|t| t.text}
  assert (titles.index(e1) ? titles.index(e1) : 0) < (titles.index(e2) ? titles.index(e2) : 0), [ titles.index(e1), titles.index(e2)].to_s 
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
    rating_list.split(",").each do |field|
    field = field.strip
    if uncheck == "un"
       step %Q{I uncheck "ratings_#{field}"}
       step %Q{the "ratings_#{field}" checkbox should not be checked}
    else
      step %Q{I check "ratings_#{field}"}
      step %Q{the "ratings_#{field}" checkbox should be checked}
    end
  end
end

Then /^I should see movies with following ratings: (.*)/ do |rating_list|
  ratings = page.all("table#movies tbody tr td[2]").collect! {|t| t.text}
  rating_list.split(",").each do |field|
    assert ratings.include?(field.strip)
  end
end
 
Then /^I should not see movies with the following ratings: (.*)/ do |rating_list|
  ratings = page.all("table#movies tbody tr td[2]").collect! {|t| t.text}
  rating_list.split(",").each do |field|
    assert !ratings.include?(field.strip)
  end
end
 
Then /^I should see all of the movies$/ do
  assert ( rows = page.all("table#movies tbody tr td[1]").size == Movie.all.count )
end
 
Then /^I should see no movies$/ do
  assert ( rows = page.all("table#movies tbody tr td[1]").size == 0 ) 
end
