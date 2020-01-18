struct Shader
    Name
    Program
    UniformLocations
end

function Draw(shader, verts, uniformData=[])
    
    # Fix this during shader construction... whoops.
    pos_attribute = glGetAttribLocation(shader.Program, "position")
    glVertexAttribPointer(pos_attribute, 4, GL_FLOAT, GL_FALSE, 0, C_NULL)
    glEnableVertexAttribArray(pos_attribute)
    #########################################################################
    
    BindVertexData(verts)
    BindShaderProgram(shader, uniformData)
    glDrawArrays(GL_TRIANGLES, 0, verts.VertexCount)
    
end

function GetShader(gfx, name)
    return gfx.ShaderList[name] 
end

function RegisterShader(eng, shader::Shader)
    eng.Gfx.ShaderList[shader.Name] = shader
end 

function BindShaderProgram(shader::Shader, uniformValues=[])
    glUseProgram(shader.Program)
    
    unicount = length(shader.UniformLocations)
    if(unicount > 0)
        for i in 1:unicount
            SetUniformValue(shader.UniformLocations[i][2], uniformValues[i])
        end
    end
end

function SetUniformValue(loc, val::Point1f0)
    glUniform1f(loc, val.data[1])
end
function SetUniformValue(loc, val::Point2f0)
    glUniform2f(loc, val.data[1], val.data[2])
end
function SetUniformValue(loc, val::Point3f0)
    glUniform3f(loc, val.data[1], val.data[2], val.data[3])
end
function SetUniformValue(loc, val::Point4f0)
    glUniform4f(loc, val.data[1], val.data[2], val.data[3], val.data[4])
end

function CreateShader(name, vertexFilename, fragmentFilename, uniformNamesAndType)
    vert = CreateVertexShader(vertexFilename)
    frag = CreateFragmentShader(fragmentFilename)
    prog = CreateShaderProgram(vert, frag)
    
    uniforms = []
    for uniformName in uniformNamesAndType
        loc = GetUniformLocation(prog, uniformName) 
        push!(uniforms, (uniformName,loc))
    end
    
    return Shader(name, prog, uniforms)
end

function GetUniformLocation(shaderprogram, name)
     glGetUniformLocation(shaderprogram, name);
end

function CreateShaderProgram(vert, frag)
    shaderProgram = glCreateProgram()
    glAttachShader(shaderProgram, vert)
    glAttachShader(shaderProgram, frag)
    glLinkProgram(shaderProgram)
       
    return shaderProgram
end

function CreateFragmentShader(filename, entrypoint="main")
    fragmentShader = glCreateShader(GL_FRAGMENT_SHADER)
    shaderText      = read(filename, String)
    glShaderSource(fragmentShader, shaderText)
    glCompileShader(fragmentShader)
    status = Ref(GLint(0))
    glGetShaderiv(fragmentShader, GL_COMPILE_STATUS, status)
    if status[] != GL_TRUE
        buffer = zeros(UInt8,4096)
        glGetShaderInfoLog(fragmentShader, 4096, C_NULL, buffer)
        @error "$(String(buffer))"
        return nothing
    else
        return fragmentShader
    end
end

function CreateVertexShader(filename, entrypoint="main")
    vertexShader = glCreateShader(GL_VERTEX_SHADER)
    shaderText      = read(filename, String)
    glShaderSource(vertexShader, shaderText)
    glCompileShader(vertexShader)
    status = Ref(GLint(0))
    glGetShaderiv(vertexShader, GL_COMPILE_STATUS, status)
    if status[] != GL_TRUE
        buffer = zeros(UInt8,4096)
        glGetShaderInfoLog(vertexShader, 4096, C_NULL, buffer)
        @error "$(String(buffer))"
        return nothing
    else
        return vertexShader
    end
end