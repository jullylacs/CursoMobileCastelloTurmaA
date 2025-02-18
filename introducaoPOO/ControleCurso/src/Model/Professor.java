package Model;

public class Professor extends Pessoa{
     //atributos (encapsulamento)
    private String getSalario;

    //métodos
    //construtor
    public Professor(String nome, String cpf, String getSalario) {
        super(nome, cpf);
        this.getSalario = getSalario;
    }
    //getter and setters
    public String getSalario() {
        return getSalario;
    }
    public void setgetSalario(String getSalario) {
        this.getSalario = getSalario;
    }
    //exibirInformações
    @Override
    public void exibirInformacoes(){
        super.exibirInformacoes();
        System.out.println("getSalario: "+getSalario);
    }
}

