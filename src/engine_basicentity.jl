mutable struct BasicEntity <: AbstractEntity
    Name::AbstractString
    
    ShaderName::AbstractString
    VertexName::AbstractString
    
    Position::Point3f0
    Scale::Point3f0
    Colour::Point4f0
end

function CreateBasicEntity(name="EMPTY", shader="BaseShader", vert="UnitQuad" )
     return BasicEntity(name, shader, vert,
                        Point3f0(0.f0, 0.f0, 0.f0), 
                        Point3f0(1.0f0, 1.0f0, 1.0f0), 
                        Point4f0(1.0f0,1.0f0,1.0f0,1.0f0))
end


function RenderEntity(eng, ent::BasicEntity, KeyState)
    shader     = GetShader(eng.Gfx, ent.ShaderName)
    vertexData = GetVertexData(eng.Gfx, ent.VertexName)
    Draw(shader, vertexData, [ent.Position, ent.Colour])
end

function UpdateEntity(eng, ent::BasicEntity, KeyState)
    if(typeof(eng.KeyState) == ControllerState)
        if(eng.KeyState.dpad.left == true)
            ent.Position -= Point3f0(0.01f0, 0.0f0, 0.0f0)
        elseif(eng.KeyState.dpad.right == true)
            ent.Position += Point3f0(0.01f0, 0.0f0, 0.0f0)
        end
    end
end