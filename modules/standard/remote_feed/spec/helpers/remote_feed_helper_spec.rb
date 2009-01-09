require File.expand_path(File.dirname(__FILE__) + '/../../../../../spec/spec_helper')

describe 'RemoteFeedHelper' do
  it 'should have remote_feed_block working well with the default block' do
    block = RemoteFeedBlock.new
    title, content = helper.remote_feed_block(block)
    title.should_not be_nil
  end
end
