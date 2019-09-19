class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :published, :author

  def author
    #self.objet hace referencia la objeto serializado
    user = self.object.user
    {
      name: user.name,
      email: user.email,
      id: user.id
    }
  end
end
