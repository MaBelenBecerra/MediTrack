import { Controller, Post, Body, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';

@Controller('api/v1/auth')
export class AuthController {
  constructor(private jwtService: JwtService) {}

  @Post('login')
  login(@Body() body: any) {
    if (body.username === 'admin' && body.password === '1234') {
      const payload = { sub: 1, username: 'admin' };
      return {
        access_token: this.jwtService.sign(payload, { secret: 'SECRETO_CATOLICA' }),
      };
    }
    throw new UnauthorizedException();
  }
}