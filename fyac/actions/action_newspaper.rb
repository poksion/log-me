# encoding: utf-8

require_relative 'action'

$CONTENT_NEWSPAPER = <<-MY_CONTENT_NEWSPAPER
<!doctype html>
<!--[if IE 9]><html class="lt-ie10" lang="en" > <![endif]-->
<html class="no-js" lang="en" data-useragent="Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.2; Trident/6.0)">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>News paper | Feed</title>

    <link rel="stylesheet" href="#{FOUNDATION}/css/foundation.css" />
    <script src="#{FOUNDATION}/js/modernizr.js"></script>
    
<!-- override style -->
 <style type="text/css">
.results {
  margin-top: 50px;
}
.results .search-results {
  margin-top: 40px;
  margin-bottom: 20px;
}
.results img {
  margin-left: auto;
  margin-right: auto;
  margin-bottom: 10px;
}
  </style>

 
  </head>
  <body>
    

 <!-- Header and Nav -->
<div class="row results">
  <div class="large-12 columns ">
    <div class="row">
      <div class="large-9 columns">
        <p> Search Results for "Cat Books: 123</p>
      </div>
      <div class=" large-3 columns ">
        <select name="sortOptions">
          <option value="sortby">Sort By</option>
          <option value="cats">Cats</option>
          <option value="title">Title</option>
          <option value="author">Author</option>
          <option value="mrecats">More Cats</option>
        </select>
      </div>
    </div>
    <div class="search-results">
      <div class="row ">
        <div class="large-2 columns">
          <a href="#"> <span> </span><img src="http://placehold.it/150x200&text=book cover" alt="book cover" class=" thumbnail"></a>
        </div>
        <div class="large-10 columns">
          <div class="row">
            <div class=" large-9 columns">
              <h5><a href="#">Do cats hear with their feet? : where cats come from, what we know about them, and what they think about us </a></h5>
              <p><a href="#"> Info</a> | <a href="#">Buy this book</a></p>
            </div>
            <div class=" large-3 columns">
              <a href="#"  class="button  expand medium"><span>Open Book</span> </a>
              <a href="#"  class="button  expand medium"><span>Add to List</span></a> 
            </div>
            <div class="row">
              <div class=" large-12 columns">
                <ul class="large-block-grid-2">
                  <li>
                    <ul>
                      <li><strong>Author: </strong>John Doe</li>
                      <li><strong>Published:</strong> 2008</li>
                      <li><strong>More info:</strong> Lorem ipsum</li>
                      <li><strong>More cat stuff: </strong> cats cats cats</li>
                    </ul>
                  </li>
                  <li>
                    <ul>
                      <li><strong>Wow cats:</strong> so wow</li>
                      <li><strong>Lorem cats:</strong> ipsum kitty</li>
                      <li><strong>Series:</strong> all the cats</li>
                    </ul>
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </div>
        <hr>
      </div>
      <div class="row ">
        <div class="large-2 columns">
          <a href="#"> <span> </span><img src="http://placehold.it/150x200&text=book cover" alt="book cover" class=" thumbnail"></a>
        </div>
        <div class="large-10 columns">
          <div class="row">
            <div class=" large-9 columns">
              <h5><a href="#">Do cats hear with their feet? : where cats come from, what we know about them, and what they think about us </a></h5>
              <p><a href="#"> Info</a> | <a href="#">Buy this book</a></p>
            </div>
            <div class=" large-3 columns">
              <a href="#"  class="button  expand medium"><span>Open Book</span> </a>
              <a href="#"  class="button  expand medium"><span>Add to List</span></a> 
            </div>
            <div class="row">
              <div class=" large-12 columns">
                <ul class="large-block-grid-2">
                  <li>
                    <ul>
                      <li><strong>Author: </strong>John Doe</li>
                      <li><strong>Published:</strong> 2008</li>
                      <li><strong>More info:</strong> Lorem ipsum</li>
                      <li><strong>More cat stuff: </strong> cats cats cats</li>
                    </ul>
                  </li>
                  <li>
                    <ul>
                      <li><strong>Wow cats:</strong> so wow</li>
                      <li><strong>Lorem cats:</strong> ipsum kitty</li>
                      <li><strong>Series:</strong> all the cats</li>
                    </ul>
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </div>
        <hr>
      </div>
      <div class="row ">
        <div class="large-2 columns">
          <a href="#"> <span> </span><img src="http://placehold.it/150x200&text=book cover" alt="book cover" class=" thumbnail"></a>
        </div>
        <div class="large-10 columns">
          <div class="row">
            <div class=" large-9 columns">
              <h5><a href="#">Do cats hear with their feet? : where cats come from, what we know about them, and what they think about us </a></h5>
              <p><a href="#"> Info</a> | <a href="#">Buy this book</a></p>
            </div>
            <div class=" large-3 columns">
              <a href="#"  class="button  expand medium"><span>Open Book</span> </a>
              <a href="#"  class="button  expand medium"><span>Add to List</span></a> 
            </div>
            <div class="row">
              <div class=" large-12 columns">
                <ul class="large-block-grid-2">
                  <li>
                    <ul>
                      <li><strong>Author: </strong>John Doe</li>
                      <li><strong>Published:</strong> 2008</li>
                      <li><strong>More info:</strong> Lorem ipsum</li>
                      <li><strong>More cat stuff: </strong> cats cats cats</li>
                    </ul>
                  </li>
                  <li>
                    <ul>
                      <li><strong>Wow cats:</strong> so wow</li>
                      <li><strong>Lorem cats:</strong> ipsum kitty</li>
                      <li><strong>Series:</strong> all the cats</li>
                    </ul>
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </div>
        <hr>
      </div>
      <div class="row ">
        <div class="large-2 columns">
          <a href="#"> <span> </span><img src="http://placehold.it/150x200&text=book cover" alt="book cover" class=" thumbnail"></a>
        </div>
        <div class="large-10 columns">
          <div class="row">
            <div class=" large-9 columns">
              <h5><a href="#">Do cats hear with their feet? : where cats come from, what we know about them, and what they think about us </a></h5>
              <p><a href="#"> Info</a> | <a href="#">Buy this book</a></p>
            </div>
            <div class=" large-3 columns">
              <a href="#"  class="button  expand medium"><span>Open Book</span> </a>
              <a href="#"  class="button  expand medium"><span>Add to List</span></a> 
            </div>
            <div class="row">
              <div class=" large-12 columns">
                <ul class="large-block-grid-2">
                  <li>
                    <ul>
                      <li><strong>Author: </strong>John Doe</li>
                      <li><strong>Published:</strong> 2008</li>
                      <li><strong>More info:</strong> Lorem ipsum</li>
                      <li><strong>More cat stuff: </strong> cats cats cats</li>
                    </ul>
                  </li>
                  <li>
                    <ul>
                      <li><strong>Wow cats:</strong> so wow</li>
                      <li><strong>Lorem cats:</strong> ipsum kitty</li>
                      <li><strong>Series:</strong> all the cats</li>
                    </ul>
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </div>
        <hr>
      </div>
    </div>
    <a href="#" class="button right"> show more results &raquo;</a>
  </div>
</div>

  </body>
</html>
MY_CONTENT_NEWSPAPER

class NewspaperAction < Action
    def content
        return $CONTENT_NEWSPAPER
    end
    
    def act(query_string)
    end
end
