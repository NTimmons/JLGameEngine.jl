struct VertexData
    Name::AbstractString
    VertexArray
    VertexBuffer
    VertexCount
end

function GetVertexData(gfx, name)
    return gfx.VertexDataList[name] 
end

function RegisterVertexData(eng, vertexData::VertexData)
    eng.Gfx.VertexDataList[vertexData.Name] = vertexData
end 

function BindVertexData(vd::VertexData)
    glBindVertexArray(vd.VertexArray[])
    glBindBuffer(GL_ARRAY_BUFFER, vd.VertexBuffer[])
end

function CreateVertexBuffer(name, vertices, drawType=GL_STATIC_DRAW)
    vao = Ref(GLuint(0))
    glGenVertexArrays(1, vao)
    glBindVertexArray(vao[])
    
    vbo = Ref(GLuint(0))
    glGenBuffers(1, vbo)
    glBindBuffer(GL_ARRAY_BUFFER, vbo[])
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW)
    
    glBindVertexArray(0)
    glBindBuffer(GL_ARRAY_BUFFER, 0)
    
    return VertexData(name, vao, vbo, length(vertices))
end 
