import Foundation

struct Personagem {
    var nome = String()
    var vida = Int()
    var vidaMaxima = Int()
    var ataque = Int()
    var defesa = Int()
    var nivel = Int()
    var experiencia = Int()
    var ouro = Int()
    var inventario = [Item]()
}
enum TipoItem {
    case pocao, arma, armadura
}
struct Item {
    let nome: String
    let tipo: TipoItem
    let valor: Int
    let preco: Int?
}
struct Inimigo {
    var nome = String()
    var vida = Int()
    var ataque = Int()
    var defesa = Int()
    var experiencia = Int()
    var ouro = Int()
}

class Jogo{
    private var personagem: Personagem?
    private var jogoAtivo: Bool = true
    private let inimigos: [Inimigo] = [
        Inimigo(nome: "Goblin", vida: 30, ataque: 8, defesa: 3, experiencia: 25, ouro: 10),
        Inimigo(nome: "Orc", vida: 50, ataque: 12, defesa: 6, experiencia: 40, ouro: 20),
        Inimigo(nome: "Esqueleto", vida: 35, ataque: 10, defesa: 4, experiencia: 30, ouro: 15),
        Inimigo(nome: "Dragão", vida: 100, ataque: 20, defesa: 10, experiencia: 100, ouro: 50)
    ]
    
    private let lojaItens: [Item] = [
        Item(nome: "Poção de Vida", tipo: .pocao, valor: 30, preco: 20),
        Item(nome: "Poção Grande", tipo: .pocao, valor: 60, preco: 35),
        Item(nome: "Espada de Ferro", tipo: .arma, valor: 10, preco: 50),
        Item(nome: "Armadura de Couro", tipo: .armadura, valor: 8, preco: 40)
    ]
    
    init() {
        print("Bem-vindo ao RPG")
        print(String(repeating: "=", count: 50))
        self.personagem = self.criarPersonagem()
    }
    
    private func criarPersonagem() -> Personagem{
        print("Digite o nome do seu personagem:")
        if let nome = readLine(){
            return Personagem(
                nome: nome,
                vida: 100,
                vidaMaxima: 100,
                ataque: 15,
                defesa: 8,
                nivel: 1,
                experiencia: 0,
                ouro: 50,
                inventario: [
                    Item(nome: "Poção de Vida", tipo: .pocao, valor: 30, preco: nil)
                ]
            )
        }
        return Personagem(
            nome: "Aventureiro",
            vida: 100,
            vidaMaxima: 100,
            ataque: 15,
            defesa: 8,
            nivel: 1,
            experiencia: 0,
            ouro: 50,
            inventario: []
        )
    }
    
    func iniciar() {
        while jogoAtivo {
            mostrarMenuPrincipal()
        }
    }
    
    private func mostrarMenuPrincipal(){
        print(String(repeating: "=", count: 50))
        print("MENU PRINCIPAL")
        print(String(repeating: "=", count: 50))
        print("1. Explorar")
        print("2. Status do Personagem")
        print("3. Inventário")
        print("4. Loja")
        print("5. Sair")
        print(String(repeating: "-", count: 30))
        print("Escolha uma opção de 1 a 5: ")
        if let num = readLine(), let escolha = Int(num){
            switch escolha{
            case 1:
                explorar()
            case 2:
                mostrarStatus()
            case 3:
                mostrarInventario()
            case 4:
                visitarLoja()
            case 5:
                sairDoJogo()
            default:
                print("Opção Inválida")
            }
            
        }
    }
    private func explorar() {
        print("\n Você está explorando a floresta...")
        
        if Int.random(in: 1...100) <= 70 {
            encontrarInimigo()
        } else {
            print("A floresta está tranquila. Você não encontrou nenhum inimigo.")
            print("Você ganhou 10 de experiência por explorar!")
            ganharExperiencia(10)
        }
    }
    
    private func encontrarInimigo(){
        let inimigo = inimigos.randomElement()!
        print("\nUm \(inimigo.nome) selvagem apareceu!")
        
        var inimigoAtual = inimigo
        var combateAtivo = true
        if let personagem = self.personagem {
            while combateAtivo && personagem.vida > 0 && inimigo.vida > 0{
                print(String(repeating: "-", count: 30))
                print("\(personagem.nome): Vida: \(personagem.vida)/\(personagem.vidaMaxima)")
                print("\(inimigoAtual.nome): Vida: \(inimigoAtual.vida)")
                print(String(repeating: "-", count: 30))
                print("1. Atacar")
                print("2. Usar Poção")
                print("3. Fugir")
                print("Escolha sua ação:")
                if let esco = readLine(), let acao = Int(esco){
                    switch acao{
                    case 1:
                        atacar(inimigo: &inimigoAtual)
                    case 2:
                        usarPocao()
                    case 3:
                        if fugir(){
                            combateAtivo = false
                            print("Você fugiu com sucesso!")
                        }
                    default:
                        print("Ação Inválida")
                    }
                    if combateAtivo && inimigo.vida > 0{
                        inimigoAtaca(inimigo: inimigoAtual)
                    }
                    if inimigoAtual.vida <= 0{
                        print("Você derrotou o \(inimigo.nome)!")
                        ganharRecompensa(inimigo: inimigoAtual)
                        combateAtivo = false
                    }
                    if personagem.vida <= 0{
                        print("Você foi derrotado pelo \(inimigo.nome)")
                        gameOver()
                        combateAtivo = false
                    }
                    
                }
            }
        }
        
    }
    private func atacar(inimigo: inout Inimigo){
        if let personagem = self.personagem {
            let dano = max(1, personagem.ataque - inimigo.defesa / 2)
            inimigo.vida -= dano
            print("Você atacou o \(inimigo.nome) e causou \(dano) de dano!")
        }
    }
    
    private func inimigoAtaca(inimigo: Inimigo) {
        if var personagem = self.personagem {
            let dano = max(1, inimigo.ataque - personagem.defesa / 2)
            personagem.vida -= dano
            print("\(inimigo.nome) atacou você e causou \(dano) de dano!")
        }
    }
    
    private func usarPocao(){
        if var personagem = self.personagem {
            let pocoes = personagem.inventario.filter { $0.tipo == .pocao }
            if pocoes.isEmpty{
                print("Você não possui poções no inventário")
                return
            }
            print("\nPoções disponíveis:")
            for (index, pocao) in pocoes.enumerated() {
                print("\(index + 1). \(pocao.nome) (+\(pocao.valor) de vida)")
            }
            print("Escolha qual poção usar:")
            if let num = readLine(), let index = Int(num){
                if index > 0 && index <= pocoes.count{
                    let pocaoEscolhida = pocoes[index - 1]
                    var vidaRecuperada = 0
                    if personagem.vida + pocaoEscolhida.valor >= personagem.vidaMaxima{
                        vidaRecuperada = personagem.vidaMaxima - personagem.vida
                    }
                    else{
                        vidaRecuperada = pocaoEscolhida.valor
                        personagem.vida = vidaRecuperada
                    }

                    if let indexInventario = personagem.inventario.firstIndex(where: { $0.nome == pocaoEscolhida.nome }) {
                        personagem.inventario.remove(at: indexInventario)
                    }
                    print("Você usou \(pocaoEscolhida.nome) e recuperou \(vidaRecuperada) de vida!")
                    print("Vida atual: \(personagem.vida)/\(personagem.vidaMaxima)")
                }
            }
            else{
                print("Opção Inválida")
                return
            }
        }
    }
    private func fugir() -> Bool{
        let chanceFugir = 60
        let sucesso = Int.random(in: 1...100)
        if sucesso <= chanceFugir{
            return true
        }
        else{
            print("Você não conseguiu fugir!")
            return false
        }
    }
    
    private func ganharRecompensa(inimigo: Inimigo){
        if var personagem = self.personagem {
            print("Você ganhou \(inimigo.ouro) de ouro!")
            print("Você ganhou \(inimigo.experiencia) de experiência!")
            personagem.ouro += inimigo.ouro
            ganharExperiencia(inimigo.experiencia)
        }
    }
    
    private func ganharExperiencia(_ quantidade: Int){
        if var personagem = self.personagem {
            personagem.experiencia += quantidade
            print("Experiência: \(personagem.experiencia)/\(nivelProximo())")
            
            while personagem.experiencia >= nivelProximo(){
                subirNivel()
            }
        }
    }
    
    private func nivelProximo() -> Int{
        if let personagem = self.personagem {
            return personagem.nivel * 100
        }
        return 0
    }
    
    private func subirNivel(){
        if var personagem = self.personagem {
            personagem.nivel += 1
            personagem.experiencia = 0
            personagem.vidaMaxima += 20
            personagem.vida = personagem.vidaMaxima
            personagem.ataque += 5
            personagem.defesa += 3
            print("PARABÉNS")
            print("Você subiu para o nível \(personagem.nivel)")
            print("Vida Máxima: \(personagem.vidaMaxima)")
            print("Ataque: \(personagem.ataque)")
            print("Defesa: \(personagem.defesa)")
        }
    }
    
    private func mostrarStatus(){
        print("STATUS DO PERSONAGEM")
        print(String(repeating: "=", count: 30))
        if let personagem = self.personagem {
            print("Nome: \(personagem.nome)")
            print("Nível: \(personagem.nivel)")
            print("Vida: \(personagem.vida)/\(personagem.vidaMaxima)")
            print("Ataque: \(personagem.ataque)")
            print("Defesa: \(personagem.defesa)")
            print("Experiência: \(personagem.experiencia)/\(nivelProximo())")
            print("Ouro: \(personagem.ouro)")
        }
    }
    
    private func mostrarInventario(){
        print("INVENTÁRIO")
        print(String(repeating: "-", count: 30))
        if let personagem = self.personagem {
            print("Ouro: \(personagem.ouro)")
            if personagem.inventario.isEmpty {
                print("Seu inventário está vazio.")
            } else {
                for (index, item) in personagem.inventario.enumerated() {
                    print("\(index + 1). \(item.nome)")
                }
            }
        }
    }
    
    private func visitarLoja(){
        print("\nBem-vindo à Loja!")
        if var personagem = self.personagem {
            print("Seu ouro: \(personagem.ouro)")
            print("Itens disponíveis:")
            for (index, item) in lojaItens.enumerated() {
                print("\(index + 1). \(item.nome) - \(item.preco!) ouros")
            }
            print("Escolha um item para comprar:")
            if let escolha = readLine(), let opcao = Int(escolha){
                if opcao == lojaItens.count + 1{
                    return
                }
                if opcao > 0 && opcao <= lojaItens.count{
                    let item = lojaItens[opcao - 1]
                    if personagem.ouro >= item.preco! {
                        personagem.ouro -= item.preco!
                        personagem.inventario.append(item)
                        print("Você comprou \(item.nome) por \(item.preco!) ouro!")
                    } else {
                        print("Ouro insuficiente!")
                    }
                }
                else{
                    print("Item inválido")
                }
            }
        }
        
    }
    private func gameOver(){
        print("\n Game Over!")
        print(String(repeating: "-", count: 30))
        print("Sua aventura chegou ao fim...")
        if let personagem = self.personagem {
            print("Nivel que chegou: \(personagem.nivel)")
            print("Ouro acumulado: \(personagem.ouro)")
            jogoAtivo = false
        }
    }
    
    private func sairDoJogo(){
        print("\nObrigado por jogar! Até a próxima!")
        jogoAtivo = false
    }

}

let jogo = Jogo()
jogo.iniciar()
