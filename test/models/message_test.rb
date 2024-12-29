require "test_helper"

class MessageTest < ActiveSupport::TestCase
  def setup
    @sender = users(:one)
    @receiver = users(:two)
    @message = Message.new(sender: @sender, receiver: @receiver, body: "Hello")
  end

  test "should be valid with body" do
    assert @message.valid?
  end

  test "should be invalid without body and attachment" do
    @message.body = nil
    assert_not @message.valid?
  end

  test "should be valid with attachment and without body" do
    @message.body = nil
    @message.attachment.attach(io: File.open(Rails.root.join("test", "fixtures", "files", "test_image.png")), filename: "test_image.png", content_type: "image/png")
    assert @message.valid?
  end

  test "should belong to sender" do
    assert_equal @sender, @message.sender
  end

  test "should belong to receiver" do
    assert_equal @receiver, @message.receiver
  end

  test "should identify image attachment" do
    @message.attachment.attach(io: File.open(Rails.root.join("test", "fixtures", "files", "test_image.png")), filename: "test_image.png", content_type: "image/png")
    assert @message.image?
  end

  test "should not identify non-image attachment as image" do
    @message.attachment.attach(io: File.open(Rails.root.join("test", "fixtures", "files", "test_document.pdf")), filename: "test_document.pdf", content_type: "application/pdf")
    assert_not @message.image?
  end
end
