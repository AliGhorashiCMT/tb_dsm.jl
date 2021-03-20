function graphene_bands()
    a_cc=pb_graphene.a_cc
    Gamma = [0, 0]
    K2 = [2*pi / (3*sqrt(3)*a_cc), 2*pi / (3*a_cc)]
    M = [0, 2*pi / (3*a_cc)]
    K1 = [-4*pi / (3*sqrt(3)*a_cc), 0]
    graphene_mod = pb_model(pb_graphene.monolayer(), pb.translational_symmetry())
    pb_solver(graphene_mod).calc_bands(K1, Gamma, M, K2).plot()
end

function heaviside(x::Real)
    x>0 ? 1 : 0
end

function graphene_impol(qx::Real, qy::Real, μ::Real;mesh::Int=10, histogram_width::Real=100)

    im_pols = zeros(histogram_width*30)
    b1, b2 = pb_graphene.monolayer().reciprocal_vectors()
    bzone_area = abs(cross(b1, b2)[3])
    graphene_mod = pb_model(pb_graphene.monolayer(), pb.translational_symmetry())
    graphene_solver = pb_solver(graphene_mod)
    for xiter in 1:mesh
        for yiter in 1:mesh
            kx, ky = xiter/mesh*b1[1] + yiter/mesh*b2[1], xiter/mesh*b1[2] + yiter/mesh*b2[2]
            graphene_solver.set_wave_vector([kx, ky])
            Ednk, Eupk = graphene_solver.eigenvalues[1], graphene_solver.eigenvalues[2]
            vecdnk, vecupk = graphene_solver.eigenvectors[:, 1], graphene_solver.eigenvectors[:, 2]

            graphene_solver.set_wave_vector([kx, ky]+[qx, qy])
            Ednkpluq, Eupkplusq = graphene_solver.eigenvalues[1], graphene_solver.eigenvalues[2]

            vecdnkplusq, vecupkplusq = graphene_solver.eigenvectors[:, 1], graphene_solver.eigenvectors[:, 2]

            overlap1 = abs(sum(conj(vecupkplusq).*vecdnk))^2
            overlap2 = abs(sum(conj(vecupkplusq).*vecupk))^2

            ω = Eupkplusq - Ednk
            f2 = heaviside(μ-Eupkplusq)
            f1 = heaviside(μ-Ednk)
            im_pols[round(Int, ω*histogram_width+1)] = im_pols[round(Int, ω*histogram_width+1)] + 2/(2π)^2*π*histogram_width*(f2-f1)*overlap1*(1/mesh)^2*bzone_area

            ω = Eupkplusq - Eupk
            f1 = heaviside(μ-Eupk)
            if ω > 0
                im_pols[round(Int, ω*histogram_width+1)] = im_pols[round(Int, ω*histogram_width+1)] + 2/(2π)^2*π*histogram_width*(f2-f1)*overlap2*(1/mesh)^2*bzone_area
            end            
        end
    end
    return im_pols
end

function bilayer_graphene_bands()
    a_cc=pb_graphene.a_cc
    Gamma = [0, 0]
    K2 = [2*pi / (3*sqrt(3)*a_cc), 2*pi / (3*a_cc)]
    M = [0, 2*pi / (3*a_cc)]
    K1 = [-4*pi / (3*sqrt(3)*a_cc), 0]
    graphene_mod = pb_model(pb_graphene.bilayer(), pb.translational_symmetry())
    pb_solver(graphene_mod).calc_bands(K1, Gamma, M, K2).plot()
end

function tmd_mo_s2()
    mos2_mod = pb_model(pb_mos2, pb.translational_symmetry())
    kpoints1, kpoints2, kpoints3 = [0, 0], mos2_mod.lattice.brillouin_zone()[1], mos2_mod.lattice.brillouin_zone()[2]
    pb_solver(mos2_mod).calc_bands(kpoints1, kpoints2, kpoints3).plot()
end