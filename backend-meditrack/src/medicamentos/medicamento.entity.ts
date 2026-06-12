import { Entity, Column, PrimaryGeneratedColumn } from 'typeorm';

@Entity()
export class Medicamento {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column()
  nombre!: string;

  @Column()
  dosis!: string;

  @Column()
  hora!: string;
}