package view;

import java.util.Scanner;
import Controller.Curso;
import Model.Aluno;
import Model.Professor;

public class MenuCurso {
    //atributos
    private boolean continuar = true;
    private int operacao;
    Scanner sc = new Scanner(System.in);
    //método
    public void menu(){
        //instancia curso e professor
        Professor professor = new Professor("José Pereira", "123.456;789-89", "15.000,00");
        Curso curso = new Curso("Programação Java", professor);

        while (continuar) {
            System.out.println("==Sistema de Gestão Escolar==");
            System.out.println("1. Cadastrar Aluno no Curso");
            System.out.println("2. Informações do Curso");
            System.out.println("3. Status da Turma");
            System.out.println("4.Sair");
            System.out.println("Escolha a Opção Desejada");
            operacao = sc.nextInt();
            switch (operacao) {
                case 1:
                System.out.println("Informe o nome do aluno");
                String nomeAluno = sc.next();
                System.out.println("Informe o CPF do Aluno");
                String cpfAluno = sc.next();
                System.out.println("Informe o n° do Aluno");
                String matriculaAluno = sc.next();
                System.out.println("Informe a nota do Aluno");
                String notaAluno = sc.next();
                Aluno aluno = new Aluno("Julia", "987.654.321.98", matriculaAluno, operacao);
                    break;
            case 2: 
                curso.exibirInformaçõesCurso();
                break;

            case 3:
                break;

            case 4:
            System.out.println("Saindo...");
            continuar = false;
            break;
                default:
                    break;
            }
        }

    }
}
