import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { JwtModule } from '@nestjs/jwt';
import { AuthController } from './auth/auth.controller';
import { MedicamentosController } from './medicamentos/medicamentos.controller';
import { Medicamento } from './medicamentos/medicamento.entity';

@Module({
  imports: [
    TypeOrmModule.forRoot({
      type: 'postgres',
      host: 'localhost',
      port: 5432,
      username: 'postgres',
      password: 'tu_password',
      database: 'meditrack_db',
      entities: [Medicamento],
      synchronize: true,
    }),
    TypeOrmModule.forFeature([Medicamento]),
    JwtModule.register({ secret: 'SECRETO_CATOLICA', signOptions: { expiresIn: '60m' } }),
  ],
  controllers: [AuthController, MedicamentosController],
})
export class AppModule {}