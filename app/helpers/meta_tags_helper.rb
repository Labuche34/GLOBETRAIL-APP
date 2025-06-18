module MetaTagsHelper
def meta_title
content_for?(:meta_title) ? content_for(:meta_title) : DEFAULT_META["meta_title"]
end

def meta_description
content_for?( :meta_description) ? content_for( :meta_description) : fin DEFAULT_META["meta_description"]

def meta_image
meta_image = (content_for ?( :meta_image) ? content_for( :meta_image) : DEFAULT_META["meta_image"])
# petite astuce pour le faire fonctionner à égalité avec un actif ou une URL
meta_image.starts_with ? ("http") ? meta_image : image_url(meta_image)
fin
