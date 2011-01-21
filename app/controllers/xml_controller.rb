class XmlController < ApplicationController
  access_control do
    allow all
  end
  def rss
    @feed_title = "Wiadomości Gazety Myszkowskiej"
    @articles = Article.find(:all, :order => "published_at desc",
                                   :limit => 10)
    render :layout => false
    response.headers["Content-Type"] = "application/xml; charset=utf-8"
  end
  
end
