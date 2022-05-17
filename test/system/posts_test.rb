require "application_system_test_case"

class PostsTest < ApplicationSystemTestCase
  setup do
    @post = posts(:one)
  end

  test "visiting the index" do
    visit posts_url
    assert_selector "h1", text: "Posts"
  end

  test "creating a Post" do
    visit posts_url
    click_on "New Post"

    fill_in "Title", with: @post.title
    fill_in "User", with: @post.user_id
    click_on "Create Post"

    assert_text "Post was successfully created"
    assert_selector "h1", text: "Posts"
  end

  test "updating a Post" do
    visit post_url(@post)
    click_on "Edit", match: :first

    fill_in "Title", with: @post.title
    fill_in "User", with: @post.user_id
    click_on "Update Post"

    assert_text "Post was successfully updated"
    assert_selector "h1", text: "Posts"
  end

  test "destroying a Post" do
    visit edit_post_url(@post)
    click_on "Delete", match: :first
    click_on "Confirm"

    assert_text "Post was successfully destroyed"
  end
end
